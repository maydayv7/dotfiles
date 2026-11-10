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
        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/998R2rNP/fabric-api-0.166.0%2B26.3.jar";
        hash = "sha512-3g0aUCz8/MWU4DOOkcL8+SoSOdR5BKwsPFCYDuEyxnbbpqvYHNlEnNsDg2V2g8KG9b/FwbwWCcaxO9Vp02NR0g==";
      }
      {
        name = "FabricKotlin";
        id = "Ha28R6CL";
        url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/SKW1BTL3/fabric-language-kotlin-1.14.2%2Bkotlin.2.4.21.jar";
        hash = "sha512-f7R1xKfnvfjQrKS1eYpYo1TFFEPVsfvePozzTfv3GR70I4tfB9COyUkOwYCzcWJFIzJsOtRdTtKyvlQd6UB+XQ==";
      }

      # Performance
      {
        name = "Lithium";
        id = "gvQqBUqZ";
        url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/fWv5bnZk/lithium-fabric-0.26.3%2Bmc26.3.jar";
        hash = "sha512-LKkvtTATXSut3wukzE+Tl2I0h2o4xKoCtIeyVSQA8AWvz77r9Tc/tDlv4gIFN6QtdZe42lpSuQQ1XvUdX+8HrQ==";
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
        url = "https://cdn.modrinth.com/data/VSNURh3q/versions/aOP6eqZA/c2me-fabric-mc26.3-0.4.2-alpha.0.116.jar";
        hash = "sha512-XbUT0F+QnXsJ0DW0Dw0xlF7IkR9Ne3X6JYu25jOHYbiEfJ0YBNQLZH4Xgc/BQ/990OCkOJ8Z7EbgMb57u3tQUg==";
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
        url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/uPYFkQMi/skinrestorer-2.11.1%2B26.3-fabric.jar";
        hash = "sha512-VCDKmMAY1LHvYDKcmDuOc8ywNOKRdadmBELKKyTnBsZKFdCvpUo9xVsYjWdiPpga715hvjbMV9L8EdYXe5NdOw==";
      }
      {
        name = "Veinminer";
        id = "OhduvhIc";
        url = "https://cdn.modrinth.com/data/OhduvhIc/versions/QMYktnGo/veinminer-fabric-2.13.0.jar";
        hash = "sha512-YiXgklZ+xXiDRYX4+VvGOEhxjisxdXmCk0xptd05w7T1xe4qlURxhKR2Q1vVzh+2DfYonZnAZWLjN96eaAGsUg==";
      }
      {
        name = "VeinminerEnchant";
        id = "4sP0LXxp";
        url = "https://cdn.modrinth.com/data/4sP0LXxp/versions/2Y8IKaDH/veinminer-enchant-2.13.0.jar";
        hash = "sha512-qn2o9vVSYM1jxnNiEslji/S/0UlisffMUHhU5srhR77ZRccZElYbFavXa5M/P+EiQuscRBz1TS+HYbI7qIBXEg==";
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
        url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/hif1VmML/jei-26.3-fabric-31.17.0.109.jar";
        hash = "sha512-JuFLNc2KxqJg50t5Msb0gWcUYF2VPgoYlDdh7Z8uL/LGKQ5T9aWBgRgJ5stdzoHI2Jt8oq9B+sDNeAB2hAN7sw==";
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
        url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/x9jLR94Q/voicechat-fabric-2.6.27%2B26.3.jar";
        hash = "sha512-8t5mdhwPJJuw+aSzSPmLl6tOidPtP9N2OEIDZLdDG3V5M6oIwMw+e6PdhaYC1sLeMTwjCfxYfpPKvzH8X23yfg==";
        require = "vc-port";
      }
    ];
  };
}
