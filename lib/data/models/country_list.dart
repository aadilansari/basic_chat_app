// To parse this JSON data, do
//
//     final countryList = countryListFromJson(jsonString);

import 'dart:convert';

List<CountryList> countryListFromJson(String str) => List<CountryList>.from(json.decode(str).map((x) => CountryList.fromJson(x)));

String countryListToJson(List<CountryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryList {
    final Name? name;
    final List<String>? tld;
    final String? cca2;
    final String? ccn3;
    final String? cioc;
    final bool? independent;
    final String? status;
    final bool? unMember;
    final Currencies? currencies;
    final Idd? idd;
    final List<String>? capital;
    final List<String>? altSpellings;
    final String? region;
    final String? subregion;
    final Languages? languages;
    final List<double>? latlng;
    final bool? landlocked;
    final List<String>? borders;
    final int? area;
    final Demonyms? demonyms;
    final String? cca3;
    final Map<String, Translation>? translations;
    final String? flag;
    final Maps? maps;
    final int? population;
    final Gini? gini;
    final String? fifa;
    final Car? car;
    final List<String>? timezones;
    final List<String>? continents;
    final Flags? flags;
    final CoatOfArms? coatOfArms;
    final String? startOfWeek;
    final CapitalInfo? capitalInfo;
    final PostalCode? postalCode;

    CountryList({
        this.name,
        this.tld,
        this.cca2,
        this.ccn3,
        this.cioc,
        this.independent,
        this.status,
        this.unMember,
        this.currencies,
        this.idd,
        this.capital,
        this.altSpellings,
        this.region,
        this.subregion,
        this.languages,
        this.latlng,
        this.landlocked,
        this.borders,
        this.area,
        this.demonyms,
        this.cca3,
        this.translations,
        this.flag,
        this.maps,
        this.population,
        this.gini,
        this.fifa,
        this.car,
        this.timezones,
        this.continents,
        this.flags,
        this.coatOfArms,
        this.startOfWeek,
        this.capitalInfo,
        this.postalCode,
    });

    CountryList copyWith({
        Name? name,
        List<String>? tld,
        String? cca2,
        String? ccn3,
        String? cioc,
        bool? independent,
        String? status,
        bool? unMember,
        Currencies? currencies,
        Idd? idd,
        List<String>? capital,
        List<String>? altSpellings,
        String? region,
        String? subregion,
        Languages? languages,
        List<double>? latlng,
        bool? landlocked,
        List<String>? borders,
        int? area,
        Demonyms? demonyms,
        String? cca3,
        Map<String, Translation>? translations,
        String? flag,
        Maps? maps,
        int? population,
        Gini? gini,
        String? fifa,
        Car? car,
        List<String>? timezones,
        List<String>? continents,
        Flags? flags,
        CoatOfArms? coatOfArms,
        String? startOfWeek,
        CapitalInfo? capitalInfo,
        PostalCode? postalCode,
    }) => 
        CountryList(
            name: name ?? this.name,
            tld: tld ?? this.tld,
            cca2: cca2 ?? this.cca2,
            ccn3: ccn3 ?? this.ccn3,
            cioc: cioc ?? this.cioc,
            independent: independent ?? this.independent,
            status: status ?? this.status,
            unMember: unMember ?? this.unMember,
            currencies: currencies ?? this.currencies,
            idd: idd ?? this.idd,
            capital: capital ?? this.capital,
            altSpellings: altSpellings ?? this.altSpellings,
            region: region ?? this.region,
            subregion: subregion ?? this.subregion,
            languages: languages ?? this.languages,
            latlng: latlng ?? this.latlng,
            landlocked: landlocked ?? this.landlocked,
            borders: borders ?? this.borders,
            area: area ?? this.area,
            demonyms: demonyms ?? this.demonyms,
            cca3: cca3 ?? this.cca3,
            translations: translations ?? this.translations,
            flag: flag ?? this.flag,
            maps: maps ?? this.maps,
            population: population ?? this.population,
            gini: gini ?? this.gini,
            fifa: fifa ?? this.fifa,
            car: car ?? this.car,
            timezones: timezones ?? this.timezones,
            continents: continents ?? this.continents,
            flags: flags ?? this.flags,
            coatOfArms: coatOfArms ?? this.coatOfArms,
            startOfWeek: startOfWeek ?? this.startOfWeek,
            capitalInfo: capitalInfo ?? this.capitalInfo,
            postalCode: postalCode ?? this.postalCode,
        );

    factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
        name: json["name"] == null ? null : Name.fromJson(json["name"]),
        tld: json["tld"] == null ? [] : List<String>.from(json["tld"]!.map((x) => x)),
        cca2: json["cca2"],
        ccn3: json["ccn3"],
        cioc: json["cioc"],
        independent: json["independent"],
        status: json["status"],
        unMember: json["unMember"],
        currencies: json["currencies"] == null ? null : Currencies.fromJson(json["currencies"]),
        idd: json["idd"] == null ? null : Idd.fromJson(json["idd"]),
        capital: json["capital"] == null ? [] : List<String>.from(json["capital"]!.map((x) => x)),
        altSpellings: json["altSpellings"] == null ? [] : List<String>.from(json["altSpellings"]!.map((x) => x)),
        region: json["region"],
        subregion: json["subregion"],
        languages: json["languages"] == null ? null : Languages.fromJson(json["languages"]),
        latlng: json["latlng"] == null ? [] : List<double>.from(json["latlng"]!.map((x) => x?.toDouble())),
        landlocked: json["landlocked"],
        borders: json["borders"] == null ? [] : List<String>.from(json["borders"]!.map((x) => x)),
        area: json["area"],
        demonyms: json["demonyms"] == null ? null : Demonyms.fromJson(json["demonyms"]),
        cca3: json["cca3"],
        translations: Map.from(json["translations"]!).map((k, v) => MapEntry<String, Translation>(k, Translation.fromJson(v))),
        flag: json["flag"],
        maps: json["maps"] == null ? null : Maps.fromJson(json["maps"]),
        population: json["population"],
        gini: json["gini"] == null ? null : Gini.fromJson(json["gini"]),
        fifa: json["fifa"],
        car: json["car"] == null ? null : Car.fromJson(json["car"]),
        timezones: json["timezones"] == null ? [] : List<String>.from(json["timezones"]!.map((x) => x)),
        continents: json["continents"] == null ? [] : List<String>.from(json["continents"]!.map((x) => x)),
        flags: json["flags"] == null ? null : Flags.fromJson(json["flags"]),
        coatOfArms: json["coatOfArms"] == null ? null : CoatOfArms.fromJson(json["coatOfArms"]),
        startOfWeek: json["startOfWeek"],
        capitalInfo: json["capitalInfo"] == null ? null : CapitalInfo.fromJson(json["capitalInfo"]),
        postalCode: json["postalCode"] == null ? null : PostalCode.fromJson(json["postalCode"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name?.toJson(),
        "tld": tld == null ? [] : List<dynamic>.from(tld!.map((x) => x)),
        "cca2": cca2,
        "ccn3": ccn3,
        "cioc": cioc,
        "independent": independent,
        "status": status,
        "unMember": unMember,
        "currencies": currencies?.toJson(),
        "idd": idd?.toJson(),
        "capital": capital == null ? [] : List<dynamic>.from(capital!.map((x) => x)),
        "altSpellings": altSpellings == null ? [] : List<dynamic>.from(altSpellings!.map((x) => x)),
        "region": region,
        "subregion": subregion,
        "languages": languages?.toJson(),
        "latlng": latlng == null ? [] : List<dynamic>.from(latlng!.map((x) => x)),
        "landlocked": landlocked,
        "borders": borders == null ? [] : List<dynamic>.from(borders!.map((x) => x)),
        "area": area,
        "demonyms": demonyms?.toJson(),
        "cca3": cca3,
        "translations": Map.from(translations!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "flag": flag,
        "maps": maps?.toJson(),
        "population": population,
        "gini": gini?.toJson(),
        "fifa": fifa,
        "car": car?.toJson(),
        "timezones": timezones == null ? [] : List<dynamic>.from(timezones!.map((x) => x)),
        "continents": continents == null ? [] : List<dynamic>.from(continents!.map((x) => x)),
        "flags": flags?.toJson(),
        "coatOfArms": coatOfArms?.toJson(),
        "startOfWeek": startOfWeek,
        "capitalInfo": capitalInfo?.toJson(),
        "postalCode": postalCode?.toJson(),
    };
}

class CapitalInfo {
    final List<double>? latlng;

    CapitalInfo({
        this.latlng,
    });

    CapitalInfo copyWith({
        List<double>? latlng,
    }) => 
        CapitalInfo(
            latlng: latlng ?? this.latlng,
        );

    factory CapitalInfo.fromJson(Map<String, dynamic> json) => CapitalInfo(
        latlng: json["latlng"] == null ? [] : List<double>.from(json["latlng"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "latlng": latlng == null ? [] : List<dynamic>.from(latlng!.map((x) => x)),
    };
}

class Car {
    final List<String>? signs;
    final String? side;

    Car({
        this.signs,
        this.side,
    });

    Car copyWith({
        List<String>? signs,
        String? side,
    }) => 
        Car(
            signs: signs ?? this.signs,
            side: side ?? this.side,
        );

    factory Car.fromJson(Map<String, dynamic> json) => Car(
        signs: json["signs"] == null ? [] : List<String>.from(json["signs"]!.map((x) => x)),
        side: json["side"],
    );

    Map<String, dynamic> toJson() => {
        "signs": signs == null ? [] : List<dynamic>.from(signs!.map((x) => x)),
        "side": side,
    };
}

class CoatOfArms {
    final String? png;
    final String? svg;

    CoatOfArms({
        this.png,
        this.svg,
    });

    CoatOfArms copyWith({
        String? png,
        String? svg,
    }) => 
        CoatOfArms(
            png: png ?? this.png,
            svg: svg ?? this.svg,
        );

    factory CoatOfArms.fromJson(Map<String, dynamic> json) => CoatOfArms(
        png: json["png"],
        svg: json["svg"],
    );

    Map<String, dynamic> toJson() => {
        "png": png,
        "svg": svg,
    };
}

class Currencies {
    final Xof? xof;

    Currencies({
        this.xof,
    });

    Currencies copyWith({
        Xof? xof,
    }) => 
        Currencies(
            xof: xof ?? this.xof,
        );

    factory Currencies.fromJson(Map<String, dynamic> json) => Currencies(
        xof: json["XOF"] == null ? null : Xof.fromJson(json["XOF"]),
    );

    Map<String, dynamic> toJson() => {
        "XOF": xof?.toJson(),
    };
}

class Xof {
    final String? symbol;
    final String? name;

    Xof({
        this.symbol,
        this.name,
    });

    Xof copyWith({
        String? symbol,
        String? name,
    }) => 
        Xof(
            symbol: symbol ?? this.symbol,
            name: name ?? this.name,
        );

    factory Xof.fromJson(Map<String, dynamic> json) => Xof(
        symbol: json["symbol"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
    };
}

class Demonyms {
    final Eng? eng;
    final Eng? fra;

    Demonyms({
        this.eng,
        this.fra,
    });

    Demonyms copyWith({
        Eng? eng,
        Eng? fra,
    }) => 
        Demonyms(
            eng: eng ?? this.eng,
            fra: fra ?? this.fra,
        );

    factory Demonyms.fromJson(Map<String, dynamic> json) => Demonyms(
        eng: json["eng"] == null ? null : Eng.fromJson(json["eng"]),
        fra: json["fra"] == null ? null : Eng.fromJson(json["fra"]),
    );

    Map<String, dynamic> toJson() => {
        "eng": eng?.toJson(),
        "fra": fra?.toJson(),
    };
}

class Eng {
    final String? f;
    final String? m;

    Eng({
        this.f,
        this.m,
    });

    Eng copyWith({
        String? f,
        String? m,
    }) => 
        Eng(
            f: f ?? this.f,
            m: m ?? this.m,
        );

    factory Eng.fromJson(Map<String, dynamic> json) => Eng(
        f: json["f"],
        m: json["m"],
    );

    Map<String, dynamic> toJson() => {
        "f": f,
        "m": m,
    };
}

class Flags {
    final String? png;
    final String? svg;
    final String? alt;

    Flags({
        this.png,
        this.svg,
        this.alt,
    });

    Flags copyWith({
        String? png,
        String? svg,
        String? alt,
    }) => 
        Flags(
            png: png ?? this.png,
            svg: svg ?? this.svg,
            alt: alt ?? this.alt,
        );

    factory Flags.fromJson(Map<String, dynamic> json) => Flags(
        png: json["png"],
        svg: json["svg"],
        alt: json["alt"],
    );

    Map<String, dynamic> toJson() => {
        "png": png,
        "svg": svg,
        "alt": alt,
    };
}

class Gini {
    final double? the2015;

    Gini({
        this.the2015,
    });

    Gini copyWith({
        double? the2015,
    }) => 
        Gini(
            the2015: the2015 ?? this.the2015,
        );

    factory Gini.fromJson(Map<String, dynamic> json) => Gini(
        the2015: json["2015"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "2015": the2015,
    };
}

class Idd {
    final String? root;
    final List<String>? suffixes;

    Idd({
        this.root,
        this.suffixes,
    });

    Idd copyWith({
        String? root,
        List<String>? suffixes,
    }) => 
        Idd(
            root: root ?? this.root,
            suffixes: suffixes ?? this.suffixes,
        );

    factory Idd.fromJson(Map<String, dynamic> json) => Idd(
        root: json["root"],
        suffixes: json["suffixes"] == null ? [] : List<String>.from(json["suffixes"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "root": root,
        "suffixes": suffixes == null ? [] : List<dynamic>.from(suffixes!.map((x) => x)),
    };
}

class Languages {
    final String? fra;

    Languages({
        this.fra,
    });

    Languages copyWith({
        String? fra,
    }) => 
        Languages(
            fra: fra ?? this.fra,
        );

    factory Languages.fromJson(Map<String, dynamic> json) => Languages(
        fra: json["fra"],
    );

    Map<String, dynamic> toJson() => {
        "fra": fra,
    };
}

class Maps {
    final String? googleMaps;
    final String? openStreetMaps;

    Maps({
        this.googleMaps,
        this.openStreetMaps,
    });

    Maps copyWith({
        String? googleMaps,
        String? openStreetMaps,
    }) => 
        Maps(
            googleMaps: googleMaps ?? this.googleMaps,
            openStreetMaps: openStreetMaps ?? this.openStreetMaps,
        );

    factory Maps.fromJson(Map<String, dynamic> json) => Maps(
        googleMaps: json["googleMaps"],
        openStreetMaps: json["openStreetMaps"],
    );

    Map<String, dynamic> toJson() => {
        "googleMaps": googleMaps,
        "openStreetMaps": openStreetMaps,
    };
}

class Name {
    final String? common;
    final String? official;
    final NativeName? nativeName;

    Name({
        this.common,
        this.official,
        this.nativeName,
    });

    Name copyWith({
        String? common,
        String? official,
        NativeName? nativeName,
    }) => 
        Name(
            common: common ?? this.common,
            official: official ?? this.official,
            nativeName: nativeName ?? this.nativeName,
        );

    factory Name.fromJson(Map<String, dynamic> json) => Name(
        common: json["common"],
        official: json["official"],
        nativeName: json["nativeName"] == null ? null : NativeName.fromJson(json["nativeName"]),
    );

    Map<String, dynamic> toJson() => {
        "common": common,
        "official": official,
        "nativeName": nativeName?.toJson(),
    };
}

class NativeName {
    final Translation? fra;

    NativeName({
        this.fra,
    });

    NativeName copyWith({
        Translation? fra,
    }) => 
        NativeName(
            fra: fra ?? this.fra,
        );

    factory NativeName.fromJson(Map<String, dynamic> json) => NativeName(
        fra: json["fra"] == null ? null : Translation.fromJson(json["fra"]),
    );

    Map<String, dynamic> toJson() => {
        "fra": fra?.toJson(),
    };
}

class Translation {
    final String? official;
    final String? common;

    Translation({
        this.official,
        this.common,
    });

    Translation copyWith({
        String? official,
        String? common,
    }) => 
        Translation(
            official: official ?? this.official,
            common: common ?? this.common,
        );

    factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        official: json["official"],
        common: json["common"],
    );

    Map<String, dynamic> toJson() => {
        "official": official,
        "common": common,
    };
}

class PostalCode {
    final dynamic format;
    final dynamic regex;

    PostalCode({
        this.format,
        this.regex,
    });

    PostalCode copyWith({
        dynamic format,
        dynamic regex,
    }) => 
        PostalCode(
            format: format ?? this.format,
            regex: regex ?? this.regex,
        );

    factory PostalCode.fromJson(Map<String, dynamic> json) => PostalCode(
        format: json["format"],
        regex: json["regex"],
    );

    Map<String, dynamic> toJson() => {
        "format": format,
        "regex": regex,
    };
}
