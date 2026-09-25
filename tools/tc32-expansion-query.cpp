// tc32-expansion-query.cpp - report whether a measComp TC-32 or E-TC32 has
// the EXP-32 expansion attached, using the installed uldaq library.
//
// The device is selected with the same uniqueID rules as the measComp driver
// (measCompCreateDevice): an IP address or DNS name with an optional
// ":port" selects an Ethernet device through ulGetNetDaqDeviceDescriptor
// unless the discovered inventory already lists that address; any other value
// must match exactly one inventory uniqueId (USB serial number or Ethernet
// MAC address). The selected device is connected, DEV_CFG_HAS_EXP is read
// with ulDevGetConfig, and the device identity, API result, and flag are
// printed as key=value lines. The flag is printed only when the query
// succeeds.
//
// Run it while the IOC that owns the device is stopped: both open the same
// device.
//
// Exit status:
//   0  query succeeded; has_exp is printed
//   2  usage error
//   3  no device or more than one device matches the uniqueID
//   4  a uldaq call failed

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

#include <arpa/inet.h>
#include <netdb.h>
#include <sys/socket.h>

#include "uldaq.h"

namespace {

const int kExitOk = 0;
const int kExitUsage = 2;
const int kExitNoMatch = 3;
const int kExitApi = 4;

const unsigned short kDefaultDiscoveryPort = 54211;
const double kNetTimeoutSec = 1.0;
const unsigned int kMaxDevices = 100;

void printUsage(const char *prog)
{
    std::fprintf(stderr,
        "Usage: %s UNIQUE_ID\n"
        "\n"
        "UNIQUE_ID is the value the IOC passes to the measComp driver:\n"
        "  a USB serial number (hex, no 0x), an Ethernet MAC address,\n"
        "  or an IP address or DNS name with an optional :port.\n",
        prog);
}

void printApiError(const char *call, UlError err)
{
    char msg[ERR_MSG_LEN] = {0};
    ulGetErrMsg(err, msg);
    std::printf("api_call=%s\n", call);
    std::printf("api_result=%d\n", static_cast<int>(err));
    std::printf("api_message=%s\n", msg);
}

// Splits "host[:port]" when the value contains exactly one colon and resolves
// the host to a dotted IPv4 address. A MAC address (several colons), a bare
// hex serial number, or an unresolvable name returns false, as the driver's
// aToIPAddr does.
bool resolveIpv4(const std::string &uniqueId, std::string &dottedIp,
                 unsigned short &port)
{
    std::string host = uniqueId;
    port = kDefaultDiscoveryPort;

    std::size_t colon = uniqueId.find(':');
    if (colon != std::string::npos) {
        if (uniqueId.find(':', colon + 1) != std::string::npos) return false;
        host = uniqueId.substr(0, colon);
        char *end = NULL;
        long value = std::strtol(uniqueId.c_str() + colon + 1, &end, 10);
        if (*end != '\0' || value <= 0 || value > 65535) return false;
        port = static_cast<unsigned short>(value);
    }

    struct addrinfo hints;
    std::memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    struct addrinfo *result = NULL;
    if (getaddrinfo(host.c_str(), NULL, &hints, &result) != 0) return false;

    char buf[INET_ADDRSTRLEN] = {0};
    const struct sockaddr_in *sin =
        reinterpret_cast<const struct sockaddr_in *>(result->ai_addr);
    const char *ok = inet_ntop(AF_INET, &sin->sin_addr, buf, sizeof(buf));
    freeaddrinfo(result);
    if (!ok) return false;
    dottedIp = buf;
    return true;
}

bool isHexSerial(const std::string &uniqueId)
{
    char *end = NULL;
    std::strtol(uniqueId.c_str(), &end, 16);
    return !uniqueId.empty() && *end == '\0';
}

}  // namespace

int main(int argc, char **argv)
{
    if (argc != 2 || argv[1][0] == '\0') {
        printUsage(argv[0]);
        return kExitUsage;
    }
    const std::string uniqueId = argv[1];
    std::printf("requested_unique_id=%s\n", uniqueId.c_str());

    DaqDeviceDescriptor inventory[kMaxDevices];
    unsigned int numDevices = kMaxDevices;
    UlError err = ulGetDaqDeviceInventory(ANY_IFC, inventory, &numDevices);
    if (err != ERR_NO_ERROR) {
        printApiError("ulGetDaqDeviceInventory", err);
        return kExitApi;
    }
    std::printf("inventory_count=%u\n", numDevices);

    DaqDeviceDescriptor selected;
    std::memset(&selected, 0, sizeof(selected));
    int matches = 0;

    std::string dottedIp;
    unsigned short port = 0;
    if (!isHexSerial(uniqueId) && resolveIpv4(uniqueId, dottedIp, port)) {
        std::printf("selection=ip %s:%u\n", dottedIp.c_str(), port);
        for (unsigned int i = 0; i < numDevices; ++i) {
            if (dottedIp == inventory[i].reserved) {
                selected = inventory[i];
                ++matches;
            }
        }
        if (matches == 0) {
            err = ulGetNetDaqDeviceDescriptor(dottedIp.c_str(), port, NULL,
                                              &selected, kNetTimeoutSec);
            if (err != ERR_NO_ERROR) {
                printApiError("ulGetNetDaqDeviceDescriptor", err);
                std::printf("match_count=0\n");
                return kExitNoMatch;
            }
            matches = 1;
        }
    } else {
        std::printf("selection=unique_id\n");
        for (unsigned int i = 0; i < numDevices; ++i) {
            if (uniqueId == inventory[i].uniqueId) {
                selected = inventory[i];
                ++matches;
            }
        }
    }

    std::printf("match_count=%d\n", matches);
    if (matches != 1) {
        std::fprintf(stderr, "error: expected exactly one matching device\n");
        return kExitNoMatch;
    }

    std::printf("product_name=%s\n", selected.productName);
    std::printf("product_id=0x%x\n", selected.productId);
    std::printf("unique_id=%s\n", selected.uniqueId);
    std::printf("interface=%d\n", static_cast<int>(selected.devInterface));

    DaqDeviceHandle handle = ulCreateDaqDevice(selected);
    if (handle == 0) {
        std::printf("api_call=ulCreateDaqDevice\n");
        std::printf("api_result=invalid handle\n");
        return kExitApi;
    }

    int status = kExitOk;
    err = ulConnectDaqDevice(handle);
    if (err != ERR_NO_ERROR) {
        printApiError("ulConnectDaqDevice", err);
        status = kExitApi;
    } else {
        long long hasExp = -1;
        err = ulDevGetConfig(handle, DEV_CFG_HAS_EXP, 0, &hasExp);
        if (err != ERR_NO_ERROR) {
            printApiError("ulDevGetConfig(DEV_CFG_HAS_EXP)", err);
            status = kExitApi;
        } else {
            std::printf("api_call=ulDevGetConfig(DEV_CFG_HAS_EXP)\n");
            std::printf("api_result=%d\n", static_cast<int>(err));
            std::printf("has_exp=%lld\n", hasExp);
        }
        ulDisconnectDaqDevice(handle);
    }
    ulReleaseDaqDevice(handle);
    return status;
}
