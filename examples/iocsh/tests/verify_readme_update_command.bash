#!/usr/bin/env bash
# Runs the two update-check commands of the tc32sim README literally.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
F="${IOCSH_TEST_REPO}/examples/iocsh/tc32sim"
RUN="${IOCSH_TEST_OUT}/readme-updates-$(date -u +%H%M%S)"
D="${IOCSH_TEST_OUT}/readme-updates"; rm -rf "${D}"; mkdir -p "${D}"
bash "${F}/prepare.bash" "${RUN}" > /dev/null
export TC32SIM_RUN="${RUN}"
setsid bash "${RUN}/src/simulator/tc32_emulator.bash" --port 9400 > "${D}/emu.out" 2>&1 &
EMU=$!
trap 'kill -TERM -- "-${EMU}" 2>/dev/null' EXIT
for _ in $(seq 1 40); do grep -q 'Emulator running' "${D}/emu.out" && break; iocsh_test_sleep 0.25; done
cd "${RUN}" || exit 2
iocsh_test_ioc_start tc "${D}/ioc.log" "${F}/st.cmd"; printf 'start %s\n' $?
sleep 10
# The README command lists the channels through word splitting; the check runs it as written.
# shellcheck disable=SC2046
timeout 30 camonitor $(printf 'TC32:001:Ti%d ' $(seq 0 31)) > "${RUN}/updates.txt"
awk '{n[$1]++} END {for (k in n) if (n[k] >= 2) c++; print c+0}' "${RUN}/updates.txt"
iocsh_test_ioc_stop tc
