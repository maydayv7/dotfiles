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
        url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/WXHRsMRl/lithium-fabric-0.26.1%2Bmc26.3.jar";
        hash = "sha512-rLubA3ogPwBeA6IL8dmGYBk4Srta0nZkgIoSuRljmiUB7LUvjw130n4UCZNbDb27cOAaxGZIDArkIe5AP2ScWQ==";
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
        url = "https://cdn.modrinth.com/data/VSNURh3q/versions/sSoXjAqP/c2me-fabric-mc26.3-0.4.2-alpha.0.88.jar";
        hash = "sha512-u3QdEYyI6m2Vd/7Rr/rMHx8Ke3JaYZ7pM0N8xeQDyPFHSnCKub1ALRVO/ePOZu9Ng+2VDAz099xlblJYNyOSJg==";
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
        url = "https://cdn.modrinth.com/data/OhduvhIc/versions/G10nvigw/veinminer-fabric-2.12.2.jar";
        hash = "sha512-XjGGMpijZXnS62aYFwm57tecoBV1MbRPgXiXfEIWaAENNu9EXAAyFcKD6swPayE+eylwyDkCVAFEqtjf+yQPwA==";
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
        url = "https://cdn.modrinth.com/data/uCdwusMi/versions/gfi11b05/DistantHorizons-3.3.2-26.3-fabric-neoforge.jar";
        hash = "sha512-eKN41ewRezMJIwFf5lF/z6usPbRkszIdeiW25dd90RIlyDtHB+g6xyBQfFrHGKFjkQEzIpWhxYBBPPJJj0cpWQ==";
      }
      {
        name = "JEI";
        id = "u6dRKJwZ";
        url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/wS0zzU8r/jei-26.3-fabric-31.7.0.34.jar";
        hash = "sha512-xaBTc1SuYTI93+NAQUezHhGJ9eDobNODpRFzxHmXfnWDRFFi+p0EqLaPbxeiFUWVo/W+PdzDJ+BRpZF8U6bAhA==";
      }
      {
        name = "Jade";
        id = "nvQzSEkH";
        url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/lt43vWtF/Jade-mc26.3-Fabric-26.3.1.jar";
        hash = "sha512-E1nWV2IU//rct71CAr/RYGyCerbHUUPLx3Ryae19QTH12yJqkUuakkyskuWWx5lOb+MwNnH/jVotzUHK9hPnrg==";
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
