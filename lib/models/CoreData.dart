import 'dart:convert';

CoreDataObject coreDataObjectFromJson(String str) => CoreDataObject.fromJson(json.decode(str));

String coreDataObjectToJson(CoreDataObject data) => json.encode(data.toJson());

class CoreDataObject {
    int zPk;
    int zEnt;
    int zOpt;
    int zindex;
    int zplan;
    bool zread;
    String zname;
    dynamic zorder;
    String zstartwith;
    String ztitle;

    CoreDataObject({
        this.zPk,
        this.zEnt,
        this.zOpt,
        this.zindex,
        this.zplan,
        this.zread,
        this.zname,
        this.zorder,
        this.zstartwith,
        this.ztitle,
    });

    factory CoreDataObject.fromJson(Map<String, dynamic> json) => CoreDataObject(
        zPk: json["Z_PK"],
        zEnt: json["Z_ENT"],
        zOpt: json["Z_OPT"],
        zindex: json["ZINDEX"],
        zplan: json["ZPLAN"],
        zread: json["ZREAD"] == 0 ? false : true,
        zname: json["ZNAME"],
        zorder: json["ZORDER"],
        zstartwith: json["ZSTARTWITH"],
        ztitle: json["ZTITLE"],
    );

    Map<String, dynamic> toJson() => {
        "Z_PK": zPk,
        "Z_ENT": zEnt,
        "Z_OPT": zOpt,
        "ZINDEX": zindex,
        "ZPLAN": zplan,
        "ZREAD": zread,
        "ZNAME": zname,
        "ZORDER": zorder,
        "ZSTARTWITH": zstartwith,
        "ZTITLE": ztitle,
    };
}
