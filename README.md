# MoonMarkMind

MoonMarkMind 鏄竴涓互 MoonBit 涓烘牳蹇冪殑 Markdown 鑴戝浘婕旂ず椤圭洰銆?
瀹冪洰鍓嶆敮鎸佹妸鍩轰簬鏍囬灞傜骇鐨?Markdown 鏂囨。杞崲鎴愯剳鍥捐鍥撅紝骞跺湪娴忚鍣ㄤ腑瀹屾垚涓€缁勫熀纭€缂栬緫鎿嶄綔銆傞」鐩殑閲嶇偣涓嶆槸鈥滃仛涓€涓墠绔皬鐜╁叿鈥濓紝鑰屾槸鎶婃枃妗ｆ牳蹇冩搷浣滃敖閲忔斁鍥?MoonBit 瀹炵幇锛岃娴忚鍣ㄥ眰鍙礋璐ｆ覆鏌撳拰浜や簰銆?
## 椤圭洰鐗规€?
- Markdown 鏍囬缁撴瀯瑙ｆ瀽
- MoonBit 鐢熸垚 ASCII 鑴戝浘
- 涓績鑺傜偣鍚戝乏鍙冲睍寮€鐨勮剳鍥惧竷灞€
- 鑺傜偣鎶樺彔涓庡睍寮€
- 鑺傜偣鏍囬鍙屽嚮鐩存帴缂栬緫
- 鍚岀骇鑺傜偣鎷栨嫿閲嶆帓
- 鏂板瀛愯妭鐐?- 鍒犻櫎鑺傜偣瀛愭爲
- 缂栬緫鍚庡悓姝ュ洖鍐?Markdown 涓?ASCII 瑙嗗浘

## 鏋舵瀯璇存槑

椤圭洰鐩墠鍒嗘垚涓ゅ眰锛?
- MoonBit 鏍稿績灞?  璐熻矗瑙ｆ瀽鏍囬銆佸鍑烘爲缁撴瀯 JSON銆侀噸鍛藉悕鑺傜偣銆侀噸鎺掑悓绾ц妭鐐广€佹柊澧炶妭鐐广€佸垹闄よ妭鐐癸紝骞舵妸缁撴灉閲嶆柊搴忓垪鍖栧洖 Markdown銆?- Web 浜や簰灞?  璐熻矗鑴戝浘甯冨眬銆佹寜閽簨浠躲€佹嫋鎷戒簨浠跺拰缂栬緫杈撳叆妗嗭紝骞惰皟鐢?MoonBit 缂栬瘧鍑虹殑 JS API銆?
涓昏 MoonBit 鏂囦欢锛?
- `heading_parser.mbt`
- `mindmap_renderer.mbt`
- `outline_model.mbt`
- `web_api.mbt`

涓昏鍓嶇鏂囦欢锛?
- `web/index.html`
- `web/app.js`
- `build-web.ps1`

## MoonBit 鏍稿績 API

娴忚鍣ㄥ綋鍓嶄細璋冪敤杩欎簺 MoonBit API锛?
- `outline_json(markdown)`
- `render_ascii_mindmap(markdown)`
- `rename_heading(markdown, flat_index, title)`
- `move_heading(markdown, from_flat_index, to_flat_index, place_after)`
- `add_child_heading(markdown, parent_flat_index, title)`
- `delete_heading(markdown, flat_index)`

鍏朵腑鈥滈噸鍛藉悕銆侀噸鎺掋€佹柊澧炪€佸垹闄ゃ€丮arkdown 鍥炲啓鈥濋兘宸茬粡鐢?MoonBit 椹卞姩锛屼笉鍐嶇敱鍓嶇鑷繁缁存姢鏂囨。妯″瀷銆?
## 鏈湴寮€鍙?
鍏堝畨瑁?MoonBit锛岀劧鍚庢墽琛岋細

```powershell
moon check
moon test
```

杩愯鍛戒护琛?demo锛?
```powershell
moon run cmd/main
```

鏋勫缓娴忚鍣?bundle锛?
```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1
```

鏈湴鍚姩闈欐€佹湇鍔★細

```powershell
python -m http.server 8080 -d web
```

娴忚鍣ㄨ闂細

```text
http://localhost:8080
```

## 褰撳墠浜や簰鏂瑰紡

鍦ㄦ祻瑙堝櫒 demo 涓細

- 鍙屽嚮鑺傜偣鏍囬鍙洿鎺ヤ慨鏀瑰悕绉?- 鐐瑰嚮 `+` 鍙柊澧炲瓙鑺傜偣
- 鐐瑰嚮 `脳` 鍙垹闄ゅ綋鍓嶈妭鐐瑰強鍏跺瓙鏍?- 鎷栨嫿鑺傜偣鍒板悓绾ц妭鐐逛笂鏂规垨涓嬫柟鍙噸鎺掗『搴?- 鐐瑰嚮鑺傜偣鎴栨姌鍙犳寜閽彲灞曞紑/鏀惰捣瀛愭爲

姣忔鎿嶄綔鍚庯紝宸︿晶 Markdown 杈撳叆鍖哄拰 ASCII 杈撳嚭鍖洪兘浼氬悓姝ユ洿鏂般€?
## 鏍￠獙鏂瑰紡

鏍稿績妫€鏌ュ懡浠わ細

```powershell
moon check
moon test
moon info
```

Web bundle 鐢熸垚鏂瑰紡锛?
- 搴曞眰鐢?`moon build --target js --release` 鐢熸垚
- 鍐嶉€氳繃 `build-web.ps1` 妗ユ帴鎴愭祻瑙堝櫒鍙皟鐢ㄧ殑鎺ュ彛

## 褰撳墠闄愬埗

- 鐩墠鍙敮鎸佸熀浜庢爣棰樺眰绾х殑 Markdown 妯″瀷
- 鏅€氭钀姐€佸垪琛ㄣ€佸紩鐢ㄣ€佷唬鐮佸潡绛夋鏂囧唴瀹硅繕涓嶄細淇濈湡鍥炲啓
- 褰撳墠鍙敮鎸佸悓涓€鐖惰妭鐐逛笅鐨勬嫋鎷介噸鎺?- 璺ㄧ埗鑺傜偣鎷栨嫿鏀瑰彉灞傜骇杩樻病鏈夊疄鐜?
