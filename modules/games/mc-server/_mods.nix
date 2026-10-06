## Modrinth Server Mods
# name, id, url, hash - Attribute, Project ID/slug, Download URL, SRI hash
# require - Included only when the server option is set [Optional]
{
  fabric = {
    version = "26.3";
    mods = [
      # Dependencies
      {
        name = "FabricAPI";
        id = "P7dR8mSH";
        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/bNnaTiuM/fabric-api-0.161.0%2B26.3.jar";
        hash = "sha512-7Wslhtb94R/ehHL1pSfFHpm2cCbkb5TUv9hefijOXuKZFz7hatV2zrUfOfmNMKgRCGpt6xqGpSSFnMFuEtoQnQ==";
      }
      {
        name = "FabricKotlin";
        id = "Ha28R6CL";
        url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/eRRZzGMc/fabric-language-kotlin-1.14.1%2Bkotlin.2.4.20.jar";
        hash = "sha512-kUBPh3dEZs6GBKr+p5HYzJe2A7wxDc4XyBiPlPd4PMptwU/HJs6HHKMXv+kDPBmdjYWNUShBBqAHVOlSFHcDuA==";
      }

      # Performance
      {
        name = "Lithium";
        id = "gvQqBUqZ";
        url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/xS0Q8LSi/lithium-fabric-0.26.2%2Bmc26.3.jar";
        hash = "sha512-TX/uZhMu7ccf6rk5C5LJXXBY7b2tD+z6wdg2opULl6fKRjr77eYcfvNhzmXh+Sernond5b8uDgzkhq+1xdvuQA==";
      }
      {
        name = "Krypton";
        id = "fQEb0iXm";
        url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/UugdIYJw/krypton-0.3.2.jar";
        hash = "sha512-0dV+vUE5W3WwHxMM2VA+uNIIISQko5n/nzZ/UL6PvBxkckQrM8aG53fDFI9qYJUg6PtzLHVRV8NYyyB/1NESOg==";
      }
      {
        name = "FerriteCore";
        id = "uXXizFIs";
        url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
        hash = "sha256-ITlmxy7ZZ6zHOSvrKKhm+6MB/1a5l2wueAHC233mvyI=";
      }
      {
        name = "ScalableLux";
        id = "Ps1zyz6x";
        url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/g4eqNSKd/ScalableLux-fabric-mc26.3-0.3.0-alpha.0.6-all.jar";
        hash = "sha512-3tWpOfsgq4HB8zsUfKm5gFB3Pbso3/Ft+TnH1We2JoCVIplOyNv7mef0mNxqTmLyXhQah9GO+0P3P8WtFWnMyQ==";
      }
      {
        name = "C2ME";
        id = "VSNURh3q";
        url = "https://cdn.modrinth.com/data/VSNURh3q/versions/FXjQDzq7/c2me-fabric-mc26.3-0.4.2-alpha.0.89.jar";
        hash = "sha512-tPz4K74Vv6JT46tt9Na2ToAKLM20XUyiuAQNqH9yAz/tNPT5QBaqxQdZbHj92xjbooxmQnkBgWQsrkb64os6hQ==";
      }

      # Server-side
      {
        name = "PlayerRoles";
        id = "Rt1mrUHm";
        url = "https://cdn.modrinth.com/data/Rt1mrUHm/versions/CMb2UHlv/player-roles-1.11.0.jar";
        hash = "sha512-l5Gr7bZW4CXcgc8oMfjz/hJfBtqtlH/WnJZputW3ldehyqYT5UPlpCsMZQXdO5UPyu87AToA98in14JWlzgLtQ==";
      }
      {
        name = "SkinRestorer";
        id = "ghrZDhGW";
        url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/K7BFrFJD/skinrestorer-2.11.0%2B26.3-fabric.jar";
        hash = "sha512-hPu+nGVL+haEp+uyXqK5ij/NoXb8YvRF6Wn19TH2qkAukTK3Pg8cCDwAOZYJ6ivUKoJCU/GjjmhPiyxmkTfzKg==";
      }
      {
        name = "Veinminer";
        id = "OhduvhIc";
        url = "https://cdn.modrinth.com/data/OhduvhIc/versions/Hpw3qIxS/veinminer-fabric-2.12.3.jar";
        hash = "sha512-7H+SYppgEL9mQzfJ1DNDcER9y8brKxgC72Enuw4MhYt9VusZ03K8WX6HgwNPj7kPDGbQRDM68jz2vCTxXawDjw==";
      }
      {
        name = "VeinminerEnchant";
        id = "4sP0LXxp";
        url = "https://cdn.modrinth.com/data/4sP0LXxp/versions/9C8zH5YI/veinminer-enchant-2.11.2.jar";
        hash = "sha512-E3vrBokjmfpFIZy5nLUUFalEWXnfu1t0JQNLTDlw2j1VJsL+8puGZ+xSQ48z+ZPr9WY+BuYfefVCNybD0hm43g==";
      }

      # Server and Client
      {
        name = "DistantHorizons";
        id = "uCdwusMi";
        url = "https://cdn.modrinth.com/data/uCdwusMi/versions/TGgEbP9A/DistantHorizons-3.3.4-26.3-fabric-neoforge.jar";
        hash = "sha512-C5CxsI2Zl0v8PI6Gss6yUuL5FxXtZrklAEwoM1+0Thvdu7a4BD5NTVPIftJHeJzReIsbpOP0OU7+FU4MWc/yNg==";
      }
      {
        name = "JEI";
        id = "u6dRKJwZ";
        url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/QfoQJyPO/jei-26.3-fabric-31.9.0.58.jar";
        hash = "sha512-zfUlfSuD8kVUKRzjn/BuW5wwuQwSE2vgL4d320uYvqzjFcguHsbidVPEQs0q0fufd0QiNbXOMYMYWixH2sWtuw==";
      }
      {
        name = "Jade";
        id = "nvQzSEkH";
        url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/71CTWqdE/Jade-mc26.3-Fabric-26.3.5.jar";
        hash = "sha512-LnMx5i62ZYJorpLcQt6LRp9Q3WxqnSVGpvZJuul8LN/Y1MFWCUjPRiaRddLHnGxHo2oCaF451HZ2jRj7sqKHAw==";
      }
      {
        name = "SimpleVC";
        id = "9eGKb6K1";
        url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/OLnMVWXy/voicechat-fabric-2.6.24%2B26.3.jar";
        hash = "sha512-QU61GWcwX+d0DTQBa8jj5OL6FZDhJ4rQa836Bof2UAe4JdNF3An3mpknBKUeyTuvAf5yfgu8Mv31BoKLWmXYWg==";
        require = "vc-port";
      }
    ];
  };
}
