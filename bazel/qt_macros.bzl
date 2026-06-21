def qt_wrap_cpp(name, hdrs, **kwargs):
    outs = []
    for hdr in hdrs:
        parts = hdr.split("/")
        filename = parts[-1]
        if filename.endswith(".hpp"):
            out_filename = "moc_" + filename[:-4] + ".cpp"
        elif filename.endswith(".h"):
            out_filename = "moc_" + filename[:-2] + ".cpp"
        else:
            out_filename = "moc_" + filename + ".cpp"
            
        parts[-1] = out_filename
        out = "/".join(parts)
            
        native.genrule(
            name = name + "_" + out.replace("/", "_").replace(".", "_"),
            srcs = [hdr],
            outs = [out],
            cmd = "/usr/lib/qt5/bin/moc $< -o $@",
        )
        outs.append(out)
    
    native.filegroup(
        name = name,
        srcs = outs,
        **kwargs
    )

def qt_wrap_ui(name, uis, **kwargs):
    outs = []
    for ui in uis:
        parts = ui.split("/")
        filename = parts[-1]
        out_filename = "ui_" + filename.replace(".ui", ".h")
        parts[-1] = out_filename
        out = "/".join(parts)
        
        native.genrule(
            name = name + "_" + out.replace("/", "_").replace(".", "_"),
            srcs = [ui],
            outs = [out],
            cmd = "/usr/lib/qt5/bin/uic $< -o $@",
        )
        outs.append(out)
    
    native.filegroup(
        name = name,
        srcs = outs,
        **kwargs
    )
