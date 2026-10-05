#!/usr/bin/env bash
# Syntax and ShellCheck over the loader scripts, the book build from a
# copy of the documentation, and the documented wrapper examples.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/docs_and_tools"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
R="${IOCSH_TEST_SRC:-${IOCSH_TEST_REPO}}"
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'source %s\n' "${R}"
FILES=("${R}"/tools/iocsh.bash "${R}"/tools/iocsh_elf.bash "${R}"/tools/iocsh_metadata.bash "${R}"/examples/iocsh/checkout_application.bash "${R}"/examples/iocsh/*/prepare.bash)

iocsh_test_section "bash syntax"
for f in "${FILES[@]}"; do bash -n "${f}"; printf '%s bash -n %s\n' "$?" "${f#"${R}"/}"; done | tee "${D}/syntax"
iocsh_test_check "every script passes bash -n" iocsh_test_eq "$(grep -c '^0 ' "${D}/syntax")" "${#FILES[@]}"

iocsh_test_section "ShellCheck"
if command -v shellcheck > /dev/null; then
    shellcheck --version | sed -n 2p
    shellcheck "${FILES[@]}" > "${D}/shellcheck" 2>&1; s=$?; printf 'shellcheck status %s, output lines %s\n' "${s}" "$(wc -l < "${D}/shellcheck")"; head -n 20 "${D}/shellcheck"
    iocsh_test_check "ShellCheck reports nothing" iocsh_test_eq "${s}" 0
else
    printf 'shellcheck is not installed on this host; not run here\n'
fi

iocsh_test_section "book build from a copy of the documentation"
if command -v docker > /dev/null; then
    mkdir "${D}/bookwork"; cp -a "${R}/docs" "${D}/bookwork/docs"
    ( cd "${D}/bookwork" && find docs/src -type f -print0 | sort -z | xargs -0 sha256sum > "${D}/docsrc.before" )
    docker run --rm jeonghanlee/mdbook mdbook --version
    ( cd "${D}/bookwork" && docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/work" -w /work jeonghanlee/mdbook mdbook build docs ) > "${D}/mdbook.out" 2>&1; s=$?
    printf 'mdbook build status %s\n' "${s}"; grep -i -E 'warn|error' "${D}/mdbook.out" | head -n 5
    ( cd "${D}/bookwork" && find docs/src -type f -print0 | sort -z | xargs -0 sha256sum > "${D}/docsrc.after" )
    iocsh_test_check "the book builds" iocsh_test_eq "${s}" 0
    iocsh_test_check "the build leaves docs/src unchanged" cmp -s "${D}/docsrc.before" "${D}/docsrc.after"
    for page in concepts/installed-tree concepts/module-set reference/tools-and-scripts procedures/set-up-shell; do [[ -s "${D}/bookwork/docs/book/${page}.html" ]] && printf 'built %s.html\n' "${page}"; done
else
    printf 'docker is not installed on this host; the book is not built here\n'
fi

iocsh_test_section "documented wrapper examples"
iocsh_test_env
DOC="${R}/docs/src/procedures/set-up-shell.md"
for tool in softIoc caget pvget pvxget iocsh.bash; do command -v "${tool}"; done | sed "s|${IOCSH_TEST_TREE}|<installed_tree>|" > "${D}/tools.observed"
sed -n '/command -v softIoc caget pvget pvxget iocsh.bash/,/^$/!d; p' "${DOC}" > /dev/null
awk '/Each tool resolves inside/{f=1; next} f && /```/{c++; next} f && c==1{sub(/^ +/,""); print} c==2{exit}' "${DOC}" > "${D}/tools.documented"
cat "${D}/tools.observed"
iocsh_test_check "the five tools resolve where the page says" diff "${D}/tools.documented" "${D}/tools.observed"
EX="${IOCSH_TEST_REPO}/examples/iocsh/st.cmd"
iocsh.bash -n "${EX}" | grep -v '^# elf:' | sed "s|${IOCSH_TEST_TREE}|<installed_tree>|g; s|${IOCSH_TEST_REPO}|<repo>|g; s/inspection of [0-9]* dependency/inspection of N dependency/" > "${D}/show.observed"
awk '/For the minimal example of the repository the output is as follows/{f=1; next} f && /```/{c++; next} f && c==1{sub(/^   /,""); print} c==2{exit}' "${DOC}" | sed 's/inspection of [0-9]* dependency/inspection of N dependency/' > "${D}/show.documented"
iocsh_test_check "the show-mode output equals the documented output" diff "${D}/show.documented" "${D}/show.observed"
iocsh.bash -h > "${D}/help"; printf 'help status %s\n' $?
iocsh_test_check "help names the four options and the three directive keywords" bash -c "grep -q -- '--environment' '${D}/help' && grep -q -- '--show' '${D}/help' && grep -q -- '--non-interactive' '${D}/help' && grep -q -- '--verbose' '${D}/help' && grep -q 'mod and m are accepted' '${D}/help'"
cd "${D}" || exit 2
printf 'exit\n' | iocsh.bash "${EX}" > "${D}/example.log" 2>&1; s=$?
iocsh_test_plain "${D}/example.log" > "${D}/example.plain"
grep -n -E 'runs as /dev/fd/4; generated startup|iocRun: All initialization complete|^7.0.10 >' "${D}/example.plain" | sed "s|${IOCSH_TEST_REPO}|<repo>|" | cut -c1-160
iocsh_test_check "the documented start shows the mapping line, iocInit, and the prompt, and exit leaves with 0" bash -c "[[ ${s} -eq 0 ]] && grep -q 'iocsh.bash: ${EX} runs as /dev/fd/4; generated startup runs as /dev/fd/3' '${D}/example.plain' && grep -q -- '${IOCSH_TEST_READY_TEXT}' '${D}/example.plain' && grep -q '^7.0.10 > ' '${D}/example.plain'"
iocsh_test_summary
