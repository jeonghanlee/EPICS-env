// Exercise the shipped table factory with controlled filesystem and clock inputs.
#include <atomic>
#include <cerrno>
#include <cstdlib>
#include <iostream>
#include <dlfcn.h>
#include <time.h>

#include TABLE_SOURCE

namespace {
std::atomic<bool> clock_enabled{false};
time_t clock_seconds = 0;
}

// Interpose only the OS wall clock; EPICS and linStat time handling stay real.
extern "C" int clock_gettime(clockid_t id, struct timespec* value) noexcept
{
    if(id == CLOCK_REALTIME && clock_enabled.load()) {
        value->tv_sec = clock_seconds;
        value->tv_nsec = 0;
        return 0;
    }
    using ClockFunction = int (*)(clockid_t, struct timespec*);
    static auto system_clock = reinterpret_cast<ClockFunction>(dlsym(RTLD_NEXT, "clock_gettime"));
    if(!system_clock) {
        errno = ENOSYS;
        return -1;
    }
    return system_clock(id, value);
}

int main(int argc, char** argv)
{
    if(argc != 3)
        return 2;
    clock_seconds = std::stoll(argv[2]);
    tzset();
    clock_enabled.store(true);
    TABLE_REGISTER();
    auto table = linStat::StatTable::lookup(TABLE_NAME, argv[1], linStat::Reactor{});
    time_t_wrapper observed = table->currentTime;
    if(observed.ts != clock_seconds) {
        std::cerr << "Clock boundary did not reach the real Transaction\n";
        return 3;
    }
    std::cout << "clock=" << observed.ts << "\nlast_ok=" << table->last_ok << "\n";
    for(const auto& entry : table->current) {
        std::cout << entry.first << "=";
        if(auto value = std::get_if<linStat::IntVal>(&entry.second))
            std::cout << value->first;
        else if(auto value = std::get_if<std::string>(&entry.second))
            std::cout << *value;
        std::cout << "\n";
    }
}
