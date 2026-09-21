#!/bin/sh
# Build a Chinese technical memo from a Lynis report.
# Usage: sh extras/dengbao/export-memo.sh [lynis-report.dat] [output.md]

set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

REPORT="${1:-}"
if [ -z "${REPORT}" ]; then
    if [ -f "${HOME}/lynis-report.dat" ]; then
        REPORT="${HOME}/lynis-report.dat"
    elif [ -f "/var/log/lynis-report.dat" ]; then
        REPORT="/var/log/lynis-report.dat"
    else
        echo "No lynis-report.dat found. Pass the path as argument." >&2
        exit 1
    fi
fi

if [ ! -f "${REPORT}" ]; then
    echo "Report not found: ${REPORT}" >&2
    exit 1
fi

OUT="${2:-}"
if [ -z "${OUT}" ]; then
    OUT="${SCRIPT_DIR}/technical-memo-$(date +%Y%m%d).md"
fi

hostname_val=$(awk -F= '/^hostname=/{print $2; exit}' "${REPORT}")
os_val=$(awk -F= '/^os_fullname=/{print $2; exit}' "${REPORT}")
if [ -z "${os_val}" ]; then
    os_val=$(awk -F= '/^os=/{print $2; exit}' "${REPORT}")
fi
end_time=$(awk -F= '/^report_datetime_end=/{print $2; exit}' "${REPORT}")
hardening=$(awk -F= '/^hardening_index=/{print $2; exit}' "${REPORT}")
ok_count=$(awk -F= '/^dengbao_ok=/{print $2; exit}' "${REPORT}")
gap_count=$(awk -F= '/^dengbao_gap=/{print $2; exit}' "${REPORT}")
manual_count=$(awk -F= '/^dengbao_manual=/{print $2; exit}' "${REPORT}")

{
    echo "# 等保技术自查备忘（Lynis）"
    echo ""
    echo "本文件是主机技术扫描备忘，供填写公安 **v10.2 自查工具** 和撰写自查总结时对照。"
    echo "正式自查 zip 必须用 v10.2 导出；正式自查总结必须用分局模板，由主要领导签字盖章。"
    echo ""
    echo "- 主机：${hostname_val:-unknown}"
    echo "- 系统：${os_val:-unknown}"
    echo "- 扫描结束：${end_time:-unknown}"
    echo "- 加固指数：${hardening:-unknown}"
    echo "- 对照结果：OK ${ok_count:-0} / GAP ${gap_count:-0} / 需确认 ${manual_count:-0}"
    echo "- 报告文件：${REPORT}"
    echo ""
    echo "## 控制项对照（GB/T 22239-2019）"
    echo ""
    echo "| 控制项 | 名称 | 状态 | 证据 |"
    echo "| --- | --- | --- | --- |"
    awk -F= '
        /^dengbao_control\[\]=/ {
            line=$0
            sub(/^dengbao_control\[\]=/, "", line)
            n=split(line, a, "|")
            id=a[1]; title=a[2]; status=a[3]; evidence=a[4]
            printf("| %s | %s | %s | %s |\n", id, title, status, evidence)
        }
    ' "${REPORT}"
    echo ""
    echo "## 警告（优先整改）"
    echo ""
    warn_n=$(grep -c '^warning\[\]=' "${REPORT}" 2>/dev/null || true)
    if [ -z "${warn_n}" ] || [ "${warn_n}" -eq 0 ]; then
        echo "无 warning 记录。"
    else
        echo "| 测试 | 说明 | 细节 |"
        echo "| --- | --- | --- |"
        awk -F= '
            /^warning\[\]=/ {
                line=$0
                sub(/^warning\[\]=/, "", line)
                n=split(line, a, "|")
                printf("| %s | %s | %s |\n", a[1], a[2], a[3])
            }
        ' "${REPORT}"
    fi
    echo ""
    echo "## 建议"
    echo ""
    sug_n=$(grep -c '^suggestion\[\]=' "${REPORT}" 2>/dev/null || true)
    if [ -z "${sug_n}" ] || [ "${sug_n}" -eq 0 ]; then
        echo "无 suggestion 记录。"
    else
        echo "| 测试 | 说明 | 细节 |"
        echo "| --- | --- | --- |"
        awk -F= '
            /^suggestion\[\]=/ {
                line=$0
                sub(/^suggestion\[\]=/, "", line)
                n=split(line, a, "|")
                printf("| %s | %s | %s |\n", a[1], a[2], a[3])
            }
        ' "${REPORT}"
    fi
    echo ""
    echo "## 填写官方工具时请注意"
    echo ""
    echo "1. 不要把本备忘当成自查 zip 或分局自查总结。"
    echo "2. 单位名称从工商平台复制，注意中英文括号。"
    echo "3. 网络数等于系统数。"
    echo "4. 关键信息基础设施相关项选不适用（5 家单位除外）。"
    echo "5. 无态势感知 / 综合业务平台则选否。"
    echo "6. GAP 项纳入整改（漏洞修复、按对应等级防护），不要等到测评后再自查。"
} > "${OUT}"

echo "Wrote ${OUT}"
