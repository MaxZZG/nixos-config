# DEPRECATED: 此目录已被 modules/profiles + modules/system 分层架构取代
# 新的组织方式：
#   - modules/profiles/  按主机角色组合模块
#   - modules/system/    通用系统级模块
#
# 请勿在此目录新增配置。如需要迁移旧模块，请移到 modules/system/ 并按职责拆分。
{ ... }:
{
  # 空导入，避免误引用导致重复加载
}
