#!/bin/sh
# Print the Chaoyang 2026 official self-check work that a unit still must finish.
# Lynis cannot complete these items.

set -u

TODAY=$(date +%Y%m%d)
MAIL_DEADLINE=20260930
OFFLINE_START=20261008

days_until() {
    # $1 = YYYYMMDD
    if date -d "${1}" +%s >/dev/null 2>&1; then
        target=$(date -d "${1}" +%s)
        now=$(date +%s)
    elif date -j -f "%Y%m%d" "${1}" +%s >/dev/null 2>&1; then
        target=$(date -j -f "%Y%m%d" "${1}" +%s)
        now=$(date +%s)
    else
        echo "?"
        return
    fi
    echo $(((target - now) / 86400))
}

mail_left=$(days_until "${MAIL_DEADLINE}")
offline_left=$(days_until "${OFFLINE_START}")

echo "=============================================================="
echo " 朝阳分局 2026 等保自查 — 本单位还要完成的工作"
echo " 今天：$(date +%Y-%m-%d)"
echo "=============================================================="
echo ""
echo "两套工具不要混："
echo "  现在填：2026 版自查工具 v10.2（安装显示 v10，打开显示 v10.2）"
echo "  不要当成：网络安全等级保护备案填报工具 v1.1 / v1.2（更新工具）"
echo ""
echo "官方 zip 只能由 Windows 上的 v10.2 导出。Lynis 不能代替。"
echo ""

echo "[A] 现在立刻"
echo "  [ ] 工商平台复制单位全称（注意中英文括号）"
echo "  [ ] 列出 2026-09-14 前全部已备案系统（网络数=系统数）"
echo "  [ ] 新平台综合查询 vs 历史查询，核对接没接上备案"
echo "  [ ] Windows 安装 v10.2（不要装服务器，无 mac / 信创版）"
echo "  [ ] 向分局要自查总结模板"
echo ""

echo "[B] 线上  截止 2026-09-30（还剩 ${mail_left} 天）"
echo "  [ ] 所有应自查系统填进 v10.2"
echo "  [ ] 关键信息基础设施相关项选「不适用」（5 家除外）"
echo "  [ ] 无综合业务 / 态势感知平台则选「否」"
echo "  [ ] 分局模板写总结：页眉全称、页脚页码"
echo "  [ ] 主要领导签字、盖章，扫描上传工具"
echo "  [ ] 导出自查 zip"
echo "  [ ] 发到 cysjm@gawa.bjchy.gov.cn"
echo ""

echo "[C] 平台开通后（看钉钉群公告）"
echo "  [ ] 自查 zip 自行导入「网络安全等级保护管理系统」"
echo "  [ ] 三级及以上另传测评报告（完整版 + 可编辑版，≤20MB）"
echo ""

echo "[D] 线下  2026-10-08 起（还有 ${offline_left} 天可预约）"
echo "  [ ] 钉钉私信 18701172455 预约"
echo "  [ ] 原件双面打印、勿装订，送到道家园 1 号"
echo "  [ ] 不得快递、闪送"
echo ""

echo "[E] 不要做的事"
echo "  - 不要等测评后再自查"
echo "  - 不要用更新工具导出的 zip 当自查包"
echo "  - 不要用 Lynis 备忘当正式总结"
echo "  - 8 月 10 日后新备案系统不用再填更新工具"
echo "  - 已用 v1.1 / v1.2 导出过的不用再填更新工具"
echo ""

REPORT=""
if [ -f "${HOME}/lynis-report.dat" ]; then
    REPORT="${HOME}/lynis-report.dat"
elif [ -f "/var/log/lynis-report.dat" ]; then
    REPORT="/var/log/lynis-report.dat"
fi

if [ -n "${REPORT}" ]; then
    ok=$(awk -F= '/^dengbao_ok=/{print $2; exit}' "${REPORT}")
    gap=$(awk -F= '/^dengbao_gap=/{print $2; exit}' "${REPORT}")
    manual=$(awk -F= '/^dengbao_manual=/{print $2; exit}' "${REPORT}")
    echo "[F] 本机最近一次 Lynis 等保对照（技术辅助，非正式材料）"
    echo "  报告：${REPORT}"
    echo "  符合 ${ok:-?} / 差距 ${gap:-?} / 需确认 ${manual:-?}"
    echo "  导出备忘：sh extras/dengbao/export-memo.sh"
else
    echo "[F] 本机还没有 Lynis 等保报告。有 Linux 定级对象主机时再跑："
    echo "  sh extras/dengbao/run-selfcheck.sh"
fi

echo ""
echo "联系：孙浚铭、李震  85953683 / 18701172455"
echo "工作日 9:30-11:30，14:00-17:00    道家园 1 号"
echo "填报字段：extras/dengbao/v10.2-filling-guide.md"
