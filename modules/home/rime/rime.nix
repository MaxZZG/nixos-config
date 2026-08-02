{ inputs, ... }:
let
  rimeDir = ".local/share/fcitx5/rime";
  # Build a list of file mappings: (target_name, source_name)
  # home.file will silently skip if source doesn't exist
  wanxiangFiles = [
    "wanxiang.schema.yaml"
    "wanxiang.dict.yaml"
    "wanxiang.words.dict.yaml"
    "wanxiang.symbols.yaml"
    "wanxiang.extended.dict.yaml"
    "schema.yaml"
    "dict.yaml"
    "symbols.yaml"
  ];
in
{
  # Copy wanxiang schema files from flake input
  # Only copy files that actually exist in the source
  home.file = builtins.listToAttrs (
    builtins.filter (x: x != null) (
      map (fname:
        let
          src = "${inputs.rime-wanxiang}/${fname}";
        in
        if builtins.pathExists src then
          {
            name = "${rimeDir}/${fname}";
            value = { source = src; };
          }
        else null
      ) wanxiangFiles
    )
  );

  # Default custom config to enable wanxiang schema
  home.file."${rimeDir}/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: wanxiang
      ascii_composer/switch_key:
        Caps_Lock: commit_code
        Control_L: noop
        Control_R: noop
        Shift_L: commit_code
        Shift_R: commit_code
  '';
}
