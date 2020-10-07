require 'swagger_helper'

describe 'ToolExports API' do
  path '/api/tool_exports' do
    get 'Get the list of all tool exports the current user has access to' do
      tags 'ToolExports'
      produces 'application/json'
      security [apiToken: []]
      response '200', 'OK' do
        let(:current_user) { create(:user) }
        let!(:tool_export_1) { create(:tool_export, user: current_user) }
        let!(:tool_export_2) { create(:tool_export, user: current_user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { tool_export.uuid }
        schema type: :array,
               items: { '$ref' => '#/definitions/tool_export' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(tool_export_1.name)
          expect(response.body).to include(tool_export_2.name)
        end
      end
    end
  end

  # path '/api/tool_exports' do
  #   post 'generate an tool export object uuid by sending an base64-encoded dataURL and required metadata to the Rise.' do
  #     tags 'ToolExports'
  #     security [apiToken: []]
  #     parameter name: 'HTTP_REFERER', in: :header, schema: { type: :string }, description: 'The referer header, used to identify the tool from which this call originates from'
  #     parameter name: :body, in: :body, schema: { '$ref' => '#/definitions/metadata_for_tool_export_upload' }, description: 'The data required to obtain a valid uuid for tool export upload', required: true
  #     consumes 'application/json'
  #     produces 'application/json'
  #     response '200', 'OK' do
  #       let(:current_user) { create(:user) }
  #       let!(:research_tool) { create(:research_tool, :with_example_url) }
  #       let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
  #       let(:HTTP_REFERER) { research_tool.url }
  #       let!(:resource) { create(:resource) }
  #       let!(:section_1) { create(:section, resource: resource) }
  #       let!(:section_2) { create(:section, resource: resource) }
  #       let(:body) {
  #         {
  #           name: Faker::Book.title,
  #           notes: Faker::Dune.saying,
  #           section_uuids: [section_1.uuid, section_2.uuid],
  #           file_data_uri: "data:text/plain;base64,IyAtKi0gbW9kZTogbWFuZG9rdS12aWV3OyAtKi0KIytUSVRMRTog5aea5bCR55uj6Kmp6ZuGCiMrREFURTogMjAxNS0wOS0xMSAwODozNjo1OS41NjU2ODYKIytQUk9QRVJUWTogSUQgS1I0YzAwNzMKIytQUk9QRVJUWTogQkFTRUVESVRJT04gU0JDSwojK1BST1BFUlRZOiBXSVRORVNTIFNCQ0sKIytQUk9QRVJUWTogSlVBTiAwCiMrUFJPUEVSVFk6IEZJTEUgU0IwNG4wMjI0LTAwMOWnmuWwkeebo+ipqembhi3nm67pjLIuCjxwYjpLUjRjMDA3M19TQkNLXzAwMC0xYT7Ctgrlp5rlsJHnm6Poqanpm4bnm67pjLLCtgrjgIDjgIDjgIDjgIDnpZXmm7jlsJHnm6Pmna3lt57liLrlj7Llp5rjgIDlkIjCtgrnrKzkuIDljbfCtgrjgIDpgIHliKXkuIrkupTljYHpppbCtgrjgIDjgIDpgIHni4TlsJrmm7jpjq3lpKrljp/jgIDpgIHmpYrlsJrmm7jnpa3opb/ltr3CtgrjgIDjgIDpgIHmnY7kvo3lvqHpgY7lpI/lt57jgIDpgIHmnY7otbflsYXotbTmsaDlt57CtgrjgIDjgIDpgIHlionoqbnkuovotbTlpIDlt57jgIDpgIHoo7TlpKflpKvotbTkurPlt57CtgrjgIDjgIDpgIHpn4vlg4XooYzou43jgIDpgIHlionnprnpjKvotbTomIflt54o5LqML+mmlinCtgrjgIDjgIDpgIHos4jorKnotbTlhbHln47jgIDpgIHoo7TlrrDlkJvCtgrjgIDjgIDpgIHpoafpnZ7nhormrbjotorjgIDpgIHpm43pmbbpgYronIDCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtMWI+wrYK44CA44CA44CA44CA6YCB5bSU57SE5q245o+a5bee44CA6YCB5p2O5L6N5b6h6LW06KGM54efwrYK44CA44CA44CA44CA6YCB5qWK5bCa5pu46LW05p2x5bed44CA6YCB6YKi6YOO5Lit6LW05aSq5Y6fwrYK44CA44CA44CA44CA6YCB6KO05Lit5Lie6LW06I+v5bee44CA6YCB5b6Q6LKf5aSW6LW05rKz5LitwrYK44CA44CA44CA44CA6YCB5q635L6N5b6h6LW05ZCM5bee44CA6YCB5bSU5Lit5Lie6LW06YSt5beewrYK44CA44CA44CA44CA6YCB5LiB56uv5YWs6LW05rKz6ZqC44CA6YCB6YSt5bCa5pu46LW06IiI5YWDwrYK44CA44CA44CA44CA6YCB55Sw5L2/5ZCb6LW06JSh5bee44CA6YCB54Sh5Y+v5LiK5Lq66YGK6YKKwrYK44CA44CA44CA44CA6YCB5YOn44CA6YCB5a6X5oS86KiAwrYK44CA44CA44CA44CA6YCB5a625YWE6LW05Lu744CA6YCB5bSU546E5Lqu6LW05p6c5beewrYK44CA44CA44CA44CA6YCB5Za75qCh5pu45q245q+X6Zm144CA6YCB6JGj5q2j5a2X5q245bi45beewrYK44CA44CA44CA44CA6YCB6JWt5q2j5a2X5b6A6JSh5bee44CA6YCB55Sw5Y2T5YWl6I+v5bGxwrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTJhPsK2CuOAgOOAgOmAgeiWm+WPs+WPuOi1tOiZleW3nuOAgOmAgeeOi+W7uuW+gOa4reWNl8K2CuOAgOOAgOmAgeaut+S+jeW+oemBiuWxseWNl+OAgOmAgeadjuakjeS+jeW+ocK2CuOAgOOAgOmAgeeOi+a+ueOAgOmAgeW0lOS5i+S7gcK2CuOAgOOAgOmAgeWtq+WxseS6uuOAgOmAgeiyu+mppMK2CuOAgOOAgOmAgealiuWwkeW6nOOAgOmAgeaWh+iRl+S4iuS6uumBiui2isK2CuOAgOOAgOmAgeeEoeWPr+S4iuS6uumBiui2iuOAgOmAgea0m+mZveW8teiyn+WklsK2CuOAgOOAgOmAgeeUsOS4reS4nuWFpeilv+iVg+OAgOmAgeeOi+S6gMK2CuOAgOOAgOmAgeW0lOmDjuS4rei1tOW4uOW3nuOAgOmAgeael+S9v+WQm+i1tOmCteW3nsK2CuOAgOOAgOmAgeWIpeWPi+S6usK2CuesrOS6jOWNt8K2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC0yYj7CtgrjgIDjgIDpgIHliKXkuIvlm5vljYHkuInpppbCtgrjgIDjgIDjgIDpgIHlvLXlrpfljp/jgIDpgIHnjovmsYLCtgrjgIDjgIDjgIDpgIHmnLHppJjmhbblj4rnrKzmrbjjgIDpgIHmnLHmhbbppJjmrbjoprLCtgrjgIDjgIDjgIDpgIHku7vlsIrluKvmrbjonIDjgIDpgIHlj4vkurrpgYronIDCtgrjgIDjgIDjgIDpgIHmnZznq4vmrbjonIDjgIDpgIHpn5PmuZjotbTmsZ/opb/lvp7kuovCtgrjgIDjgIDjgIDpgIHmvZjlgoXmrbjlrqPlt57jgIDpgIHlg6fpu5nnhLbCtgrjgIDjgIDjgIDpgIHpmZ/pgZDkuIrkurrjgIDpgIHnm5vnp4DmiY3otbToiInCtgrjgIDjgIDjgIDpgIHlg6fosp7lr6bmrbjmna3lt57jgIDpgIHnm6fkuozlvJ/CtgrjgIDjgIDjgIDpgIHku7vnlbnlj4rnrKzmrbjjgIDpgIHmnZzop4DCtgrjgIDjgIDjgIDpgIHni4Tlhbzorb3mrbjmlYXlsbHjgIDpgIHmupDkuK3kuJ7otbTmlrDnvoXCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtM2E+wrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTRhPsK2CuOAgOOAgOWIpeadjumkmOOAgOWIpeiDoemAuMK2CuOAgOOAgOaDnOWIpeOAgOassuWIpcK2CuOAgOOAgOWIpeadreW3nuOAgOmAgeeOi+eOhOS8r8K2CuesrOS4ieWNt8K2CuOAgOWvhOi0iOS4iuWbm+WNgeS4g+mmlsK2CuOAgOOAgOWvhOiziOWztuOAgOWvhOeOi+W6puWxheWjq8K2CuOAgOOAgOWvhOaliuiMguWNv+agoeabuOOAgOWvhOadnOW4q+e+qcK2CuOAgOOAgOWvhOadjuaZr+WFiOOAgOWvhOmFrOebp+S+jeW+ocK2CuOAgOOAgOWvhOS4u+WuouW8temDjuS4reOAgOWvhOadjuW7k+WwkeW6nMK2CuOAgOOAgOWvhOe0q+mWo+maoOiAheOAgOWvhOaliuW3qOa6kOelremFksK2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC00Yj7CtgrjgIDjgIDlr4TmrrflsK3ol6njgIDlr4TlhannnIHplqPogIHCtgrjgIDjgIDlr4TpnYjkuIDlvovluKvjgIDlr4Tpu5nnhLbkuIrkurrCtgrjgIDjgIDlr4TlvLXlgpLjgIDlr4TmnY7poLvCtgrjgIDjgIDlr4TmnY7nvqTnjonjgIDnl4XkuK3mm7jkuovlr4Tlj4vkurrCtgrjgIDjgIDkuZ3ml6Xlr4TpjKLlj6/lvqnjgIDlr4TlionotbflsYXCtgrjgIDjgIDnp4vml6Xlr4TmnY7mlK/kvb/jgIDlr4Tku6Tni5DmpZrnm7jlhazCtgrjgIDjgIDlr4TmnbHpg73nmb3os5TlrqLjgIDlr4Too7TotbflsYXCtgrjgIDjgIDlr4Tni4Tmi77pgbrjgIDlr4TlsbHkuK3oiIrlj4vCtgrjgIDjgIDlr4TnhKHlkI3poK3pmYHjgIDlr4Tpg4HkuIrkurrCtgrjgIDjgIDlr4Tlravot6/np4DmiY3jgIDlr4Tlronpmbjlj4vkurrCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtNWE+wrYK44CA44CA5a+E6aas5oi044CA5a+E6LOI5Y+45YCJwrYK44CA44CA5a+E5qWK5bel6YOo44CA5a+E6Zmc5bee546L5Y+46aaswrYK44CA44CA5a+E6LOI5bO244CA5a+E5bSU5LmL5LuB5bGx5Lq6wrYK44CA44CA5a+E5bWp5ba956iL5YWJ56+E44CA5rSb5LiL5aSc5pyD5a+E6LOI5bO2wrYK44CA44CA5a+E6I+v5bee5p2O5Lit5Lie44CA5a+E5pyx6KuM6K2wwrYK44CA44CA5a+E5p2t5bee5bSU6LKf5aSW44CA5a+E5YWD57eS5LiK5Lq6wrYK44CA44CA5a+E55m96Zaj6buZ54S244CA5a+E5LiY5YWD6JmV5aOrwrYK44CA44CA5a+E5bSU6YGT5aOr44CA5a+E6I+v5bee5bSU5Lit5LiewrYK44CA44CA5a+E56WV5pu456uH5bCR55ujwrYK56ys5Zub5Y23wrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTViPsK2CuOAgOOAgOWvhOi0iOS4i+Wbm+WNgeWbm+mmlsK2CuOAgOOAgOOAgOWvhOmAgeebp+agseelleabuOOAgOWvhOmZouS4reiruOabuemVt8K2CuOAgOOAgOOAgOabuOaHkOWvhOWPi+S6uuOAgOWvhOeEoeWPr+S4iuS6usK2CuOAgOOAgOOAgOWvhOaaieS4iuS6uuOAgOWvhOadjuW5ssK2CuOAgOOAgOOAgOWvhOiziOWztua1quS7meOAgOWvhOS5neiPr+iyu+aLvumBusK2CuOAgOOAgOOAgOWvhOS4jeeWkeS4iuS6uuOAgOWvhOS4u+WuouWKiemDjuS4rcK2CuOAgOOAgOOAgOWvhOWRqOWNgeS4g+i1t+WxheOAgOeni+WknOWvhOm7meeEtuS4iuS6usK2CuOAgOOAgOOAgOWvhOeOi+eOhOS8r+OAgOWvhOWxseS4reWPi+S6usK2CuOAgOOAgOOAgOWvhOWGheWFhOmDreerr+WFrOOAgOWvhOiUo+S6reWFvOewoeeUsOS9v+WQm8K2CuOAgOOAgOOAgOWxseWxheWvhOWPi+eUn+OAgOWvhOW0lOS5i+S7geWxseS6usK2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC02YT7CtgrjgIDjgIDlr4TkuLvlrqLlionosp/lpJbjgIDlsbHkuK3lr4Tlj4vkurrCtgrjgIDjgIDopb/lnJLlpJzlrr/lr4Tlj4vkurrjgIDljafnlr7lr4TmnY7ppJjCtgrjgIDjgIDlr4Tnmb3nn7PluKvjgIDlr4Tos4jls7bCtgrjgIDjgIDlr4Tpu5nnhLbkuIrkurrjgIDlr4TkuI3lh7rpmaLlg6fCtgrjgIDjgIDlr4TnmofnlKvnlLjjgIDlr4ToiIrlsbHpmqDogIXCtgrjgIDjgIDlr4TmnY7lu5PjgIDotIjnm6flpKflpKvlsIbou43CtgrjgIDjgIDotIjkvpvlpYnlg6fmrKHono3jgIDotIjnjovlsIrluKvCtgrjgIDjgIDotIjluLjlt57pmaLlg6fjgIDotIjnm6fmspnlvYzlsI/luKvCtgrjgIDjgIDotIjlvLXnsY3lpKrnpZ3jgIDotIjkuJjpg47kuK3CtgrjgIDjgIDotIjnjovlu7rlj7jppqzjgIDotIjku7vlo6vmm7nCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtNmI+wrYK44CA44CA6LSI5YqJ5LmJ44CA6LSI5YOn57S55piOwrYK44CA44CA6LSI5by16LOq5bGx5Lq644CA6LSI5bCR5a6k5bGx6bq76KWm5YOnwrYK44CA44CA6LSI546L5bGx5Lq644CA6LSI57WC5Y2X5bGx5YKF5bGx5Lq6wrYK56ys5LqU5Y23wrYK44CA6ZaR6YGp5LqU5Y2B5LiA6aaWwrYK44CA44CA6ZaR5bGF6YGj5oeQ5Y2B6aaW44CA5q2m5Yqf57ij5Lit5LiJ5Y2B6aaWwrYK44CA44CA57235q2m5Yqf57ij5LqM6aaW44CA56eL5pel6ZaR5bGF5LqM6aaWwrYK44CA44CA5pma5oaC6ZaR5bGF44CA6ZaR5bGFwrYK44CA44CA6KGX6KW/5bGF5LiJ6aaW44CA6ZaR5bGF6YGj6IiIwrYK44CA44CA6ZaR5bGFwrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTdhPsK2CuesrOWFreWNt8K2CuOAgOOAgOmWkemBqeaZguW6j+miqOaciOWFreWNgeS6jOmmlsK2CuOAgOOAgOiNmOWxheWNs+S6i+OAgOimquS7gemHjOWxhcK2CuOAgOOAgOiNmOWxhemHjuihjOOAgOaYpeaXpemWkeWxhcK2CuOAgOOAgOeNqOWxheOAgOaXqeaYpemWkeWxhcK2CuOAgOOAgOWOn+S4iuaWsOWxheOAgOWwhuatuOWxscK2CuOAgOOAgOWxseS4rei/sOaHkOOAgOWBtueEtuabuOaHkMK2CuOAgOOAgOWuouiIjuacieaHkOOAgOWPiuesrOW+jOWknOS4reabuOS6i8K2CuOAgOOAgOWBtumhjOOAgOaEn+aZgsK2CuOAgOOAgOaGtuWxseOAgOWuoumBiuaXheaHkMK2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC03Yj7CtgrjgIDjgIDjgIDov47mmKXjgIDpgYrmmKXljYHkuozpppbCtgrjgIDjgIDjgIDos57mmKXjgIDmmKXml6XljbPkuovCtgrjgIDjgIDjgIDmmKXml6XmsZ/mrKHjgIDmj5rlt57mmKXoqZ7kuInpppbCtgrjgIDjgIDjgIDlr5Lpo5/mm7jkuovkuozpppbjgIDmmq7mmKXmm7jkuovCtgrjgIDjgIDjgIDliKXmmKXjgIDlpI/lpJzCtgrjgIDjgIDjgIDmmKXmmZrogIzkuK3jgIDpgIHmmKXCtgrjgIDjgIDjgIDnp4vml6XmnInmh5DjgIDnp4vlpJXpgaPmh5DCtgrjgIDjgIDjgIDnp4vkuK3lpJzlnZDjgIDlkIzltJTljb/kuZ3mnIjlha3ml6Xpo7LCtgrjgIDjgIDjgIDkuZ3ml6Xmhrbnoa/lsbHoiIrlsYXjgIDnp4vmmZrmsZ/mrKHCtgrjgIDjgIDjgIDpmaTlpJzkuozpppbjgIDmmabml6XpgIHnqq7kuInpppbCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtOGE+wrYK44CA44CA6Kmg6Zuy44CA6Kmg6ZuqwrYK44CA44CA6YOh5Lit5bCN6Zuq44CA5bCN5pyIwrYK44CA44CA5YWr5pyI5Y2B5LqU5aSc47iU5pyI44CA6LOm5pyI6I+v6Ieo6Z2Z5aScwrYK44CA44CA6YWs5Lu755aH6Zuo5Lit6KaL5a+E44CA5ZKM5bqn5Li755u45YWs6Zuo5Lit5L2cwrYK44CA44CA5oOh56We6KGM6ZuowrYK56ys5LiD5Y23wrYK44CA6aGM6Kmg5Zub5Y2B5Lmd6aaWwrYK44CA44CA6aGM6bOv57+U6KW/6YOt5paw5LqtwrYK44CA44CA44CA6aGM6YeR5bee6KW/5ZyS5Lmd6aaWwrYKKOaxn+amrS/lnqPnq7kv6Jas5aCCL+efs+W6rS/ojYnplqMv6I6T6IuUL+advuWjhy9b6I+xLeWcnyso6ayvLeWMlSld5b6RL+iKreiVieWxjynCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtOGI+wrYK44CA44CA44CA5p2P5rqq5Y2B6aaWwrYKKOadj+a6qi/ok67loZgv5pyb5rGf5bOv5p2P5rC0L+aetuawtOiXpC/muJrkuIrnq7kv55+z5r2tL+a6qui3ry/mpZPmnpfloLDnn7PngKwpwrYK44CA44CA44CA6Zmc5LiL5Y6y546E5L6N5b6h5a6F5LqU6aGMwrYKKOa/r+e6k+a6qi/nq7noo4/lvpEv5Z6C6Yej5LqtL+axjuintOaziS/lkJ/oqanls7YpwrYK44CA44CA44CA6aGM5YOn6Zmi5byV5rOJ44CA6aGM5a625ZyS5paw5rGgwrYK44CA44CA44CA6Kmg55uG5rGg44CA6LK35aSq5rmW55+zwrYK44CA44CA44CA5aSp56yB5a+65q6/5YmN56uL55+z44CA5p2t5bee6KeA5r2uwrYK44CA44CA44CA6aGM5p2O6aC75paw5bGF44CA5a+E6aGM57ix5LiK5Lq66ZmiwrYK44CA44CA44CA6aGM5bGx5a+644CA6aGM6LKe5aWz56WgwrYK44CA44CA44CA6aGM6aas6LKf5aSW5paw5bGF44CA6aGM6YOt5L6N6YOO5bm95bGFwrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTlhPsK2CuOAgOOAgOmhjOWuo+e+qeaxoOS6reOAgOmhjOiWm+WNgeS6jOaxoOS6rcK2CuOAgOOAgOmhjOW0lOmnmemmrOael+S6reOAgOmhjOadreW3nuWNl+S6rcK2CuOAgOOAgOmhjOmEremnmemmrOael+S6reOAgOmhjOWOsueOhOS+jeW+oeaJgOWxhcK2CuOAgOOAgOmhjOeUsOWwhui7jeWuheOAgOmhjOW0lOmnmemmrOWuhcK2CuOAgOOAgOmhjOays+S4iuS6reOAgOmhjOmVt+WuieiWm+iyn+WkluawtOmWo8K2CuOAgOOAgOmhjOaigeWckuWFrOS4u+axoOS6reOAgOWvhOmhjOWwiemBsuWwkeWNv+mDiuWxhcK2CuesrOWFq+WNt8K2CuOAgOmBiuimveWutOmbhuS6lOWNgemmlsK2CuOAgOOAgOmBjuW8temCr+mEsuiNmOOAgOmBjualiuiZleWjq+W5veWxhcK2CuOAgOOAgOmBjuadjuSWj+Wjq+WxseWxheOAgOmBjueEoeWPr+WDp+mZosK2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC05Yj7Ctgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtOWI+wrYK44CA44CA5pS+5pyd5ZCM6YGK5puy5rGf44CA5pqB5pyb6I+v5riF5a6rwrYK44CA44CA5aSP5pel55m75qiT5pma5pyb44CA6Zy95b6M55m75qiTwrYK44CA44CA5pep5aSP6YOh5qiT5a606ZuG44CA5aSc5a605aSq5YOV55Sw5Y2/5a6FwrYK44CA44CA5pil5pel45G55bSU5bCR5Y2/5a6F44CA6LuN5Z+O5aSc45G5wrYK44CA44CA5pmm5pel54eV5YqJ6Yyy5LqL5a6F44CA5a605YWJ56aE55Sw5Y2/5a6FwrYK44CA44CA5pyD5bCG5L2c5bSU55uj5p2x5ZyS44CA5ZCM5pyD5aSq5bqc6Z+T5Y2/5a6FwrYK44CA44CA5Lme6YWS44CA5a+E6KGb5ou+6YG65Lme6YWSwrYK44CA44CA5Lme5paw6Iy244CA6KW/5o6W5a+T55u0KOaYpeaageiBni/mrpjlsZopwrYK44CA44CA5p2t5bee6YOh6b2L5Y2X5Lqt44CA6YOh5Lit6KW/5ZySwrYK44CA44CA5p2t5bee5a6Y6IiO5YG25pu444CA55yB55u05pu45LqLwrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTEwYT7CtgrjgIDjgIDmna3lt57lrpjoiI7ljbPkuovjgIDlgYfml6Xmm7jkuoso5ZGI6Zmi5LitL+WPuOW+kinCtgrjgIDjgIDmm7jnuKPkuJ7oiIrjlZTjgIDnuKPkuK3np4vlrr/CtgrjgIDjgIDlpI/lpJzlrr/msZ/pqZvjgIDpmZzln47ljbPkuovCtgrnrKzkuZ3ljbfCtgrjgIDlkozojYXphazorJ3kupTljYHkuIPpppbCtgrjgIDjgIDlkozku6Tni5DnlZnlrojnm7jlhazjgIDlkozpq5noq4zorbDlhaXnv7Doi5HCtgrjgIDjgIDlkoznm6fntabkuoso6YWs6KO0L+iyn+Wklinlkozoo7Tnq6/lhazml6nmnJ3CtgrjgIDjgIDlkozmnY7nm7go6aSe6KW/6JyAL+ebuOWFrCnlkozluqfkuLvnm7jlhawo56eL5pelL+WNs+S6iinCtgrjgIDjgIDlkozltJTlsJHnm6PpgYrlg6fpmaLjgIDlkozmnY7ntLPkuI3otbTjuJToirHCtgrjgIDjgIDlkozmnY7oiI7kurrlhqzoh7Pml6XjgIDlkozoo7Tku6Tlhawo5paw5oiQ57eR6YeOL+WgguWNs+S6iinCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtMTBiPsK2CuOAgOOAgOOAgOWSjOmhjOadjuebuOiNieWgguOAgOWSjOmEreebuOWUseWSjOipqcK2CuOAgOOAgOOAgOWSjOaIuOmDqOS+jemDjijnnIHkuK0v5pqB5q24KeWSjOWFg+WFq+mDjuS4reeni+WxhcK2CuOAgOOAgOOAgOWSjOmFrOeZveWwkeWCheimi+WvhOOAgOWSjOWKieemuemMqyjmi5zooajmh5Av6YO95pWF5Lq6KcK2CuOAgOOAgOOAgOWSjOmFrOaut+S+jeW+oeimi+WvhOOAgOWSjOadjuiGs+mDqOeni+WklcK2CuOAgOOAgOOAgOWSjOmfk+S+jemDjuWknOazm+a6quOAgOWSjOmhjOadjuS4reS4nuOVlMK2CuOAgOOAgOOAgOWSjOWOsueOhOeEoeWPryjjkbnlrr8v6KaL5a+EKeWSjOS7pOeLkOiyn+Wklijnm7TlpJwv5Y2z5LqLKcK2CuOAgOOAgOOAgOWSjOWtn+S+jeW+oSjml6nmnJ0v6KaL5a+EKeWSjOWPi+S6uuaWsOWxheWckuS4isK2CuOAgOOAgOOAgOWSjOijtOS7pOWFrOmBiuWNl+iNmOOAgOWSjOadjuiIjuS6uuiogOaHkMK2CuOAgOOAgOOAgOWSjOadjuiIjuS6uuWwjembquOAgOiNheadjumgu+engOaJjcK2CuOAgOOAgOOAgOiNheiDoemBh+OAgOiNheWPi+S6uuaLm+mBisK2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC0xMWE+wrYK44CA44CA6I2F56uH55+l6KiA44CA6YWs55Sw5bCxwrYK44CA44CA6YWs5p2O6LKf5aSW6KaL5a+E44CA6YWs5Luk54uQ6YOO5Lit6KaL5a+EwrYK44CA44CA6YWs5p2O5buT5pyb5pyI6KaL5a+E44CA6YWs55Sw5Y2/5pyr5LyP6KaL5a+EwrYK44CA44CA6YWs6Jab5aWJ5bi46KaL6LSIKOS5iy/ku4Ap6YWs55un5rGA6KuM6K2wwrYK44CA44CA6YWs5by16YOO5Lit6KaL5a+E44CA6YWs55Sw5Y2/5YWt6Z+76KaL5a+EwrYK44CA44CA6YWs5qWK5bCa5pu45Zac56e75bGF44CA6YWs55Sw5Y2/5Y2z5LqL6KaL5a+EwrYK44CA44CA6YWs5by157GN5Y+45qWt6KaL5a+E44CA6Kyd55Sw5aSn5aSr5a+EKOiMuOawii/okaHokIQpwrYK44CA44CA6Kyd5p2O5aSq5bCJ54mn5p2t5bee44CA5p2P5ZyS5a605LiK6Kyd5bqn5Li7wrYK44CA44CA6Kyd6Z+c5YWJ5LiK5Lq644CA6Kyd56em5qCh5pu4KOeEoeWPr+S4ii/kurropovoqKopwrYK44CA44CA5Zac6IOh6YGH6Iez44CA5Zac6LOI5bO26IezwrYKPHBiOktSNGMwMDczX1NCQ0tfMDAwLTExYj7CtgrjgIDjgIDllpzllrvps6zoh7PjgIDllpzpm43pmbbnp4vlpJzoqKrlrr/CtgrjgIDjgIDllpzos4jls7bpm6jkuK3oqKrlrr/jgIDllpzppqzmiLTopovpgY7CtgrjgIDjgIDlkIzliY3jgIDoqKrlg6fms5XpgJrkuI3pgYfCtgrjgIDjgIDlpJzmnJ/lj4vnlJ/kuI3oh7PjgIDlsIvlg6fkuI3pgYfCtgrnrKzljYHljbfCtgrjgIDoirHmnKjps6XnjbjlmajnlKjlk4DmjL3pm5zoqaDkupTljYHkuIPpppbCtgrjgIDjgIDlkozmnY7wpZm36ZeV47iU6JOu6Iqx44CA5ZKM546L6YOO5Lit5Y+s47iU54mh5Li5wrYK44CA44CA6Kmg5Y2X5rGg5ZiJ6JOu44CA6aGM6JGh6JCE5p62KOmXlSnCtgrjgIDjgIDnqK7okabjgIDmjqHmnb7oirHCtgrjgIDjgIDoqaDmlrDoj4rjgIDmpYrmoIHmnp3oqZ7kupTpppbCtgo8cGI6S1I0YzAwNzNfU0JDS18wMDAtMTJhPsK2CuOAgOOAgOmDoeS4reWGrOWknOiBnuibqeOAgOiBnuaWsOifrOWvhOadjumkmMK2CuOAgOOAgOiBnuifrOWvhOiziOWztuOAgOmhjOm2tOmbm8K2CuOAgOOAgOipoOm2r+OAgOiAgemmrMK2CuOAgOOAgOipoOmPoeOAgOipoOegtOWxj+miqMK2CuOAgOOAgOWPpOeikeOAgOaLvuW+l+WPpOehr8K2CuOAgOOAgOijtOWkp+Wkq+imi+mBjuOAgOisnei0iOeZvum9oeiXpOadlsK2CuOAgOOAgOipoOiytOmBiuOAgOeqrumCiuipnuS6jOmmlsK2CuOAgOOAgOWKjeWZqOipnuS4iemmluOAgOW+nui7jeaoguS6jOmmlsK2CuOAgOOAgOaVrOWul+eah+W4neaMveipnijkuIkv6aaWKeaWh+Wul+eah+W4neaMveipnijkuIkv6aaWKcK2CuOAgOOAgOiNmOaBquWkquWtkOaMveipnijkuowv6aaWKeWTreiyu+aLvumBuuW+tOWQm8K2CjxwYjpLUjRjMDA3M19TQkNLXzAwMC0xMmI+wrYK44CA44CA5ZOt56Gv5bGx5a2r6YGT5aOr44CA5ZOt6LOI5bO25LqM6aaWwrYK44CA44CA5ZKM5qWK57Wm5LqL5ZOt5oSb5aes44CA5Zac6Ka955un5L6N5b6h6Kmp5Y23wrYK44CA44CA5Zac6Ka96KO05Lit5Lie6Kmp5Y2344CA5b+D5oeQ6ZycwrYK44CA44CA6IG95YOn6Zuy56uv6Kyb57aT44CA6IeY5pel5421wrYK44CA44CA6IGe6a2P5bee6LOK56C044CA5LiL56yswrYK44CA44CA5b6X6IiO5byf5pu444CA55eF5YOnwrYK44CA44CA5oiQ5ZCN5b6M55WZ5Yil5b6e5YWE44CA5L2b6IiO6KaL6IOh5a2Q5pyJ5ZiywrYK44CA44CA5q245byK5bGF5a+E5p2O5aSq5bCJwrYK5aea5bCR55uj6Kmp6ZuG55uu6Yyy57WCwrYK"
  #         }
  #       }
  #       schema type: :object, schema: { uuid: :string }
  #       after do |example|
  #         example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
  #       end
  #       run_test! do |response|
  #         expect(response.body).to include('uuid')
  #       end
  #     end
  #   end
  # end

  # path '/api/tool_exports/{uuid}/upload' do
  #   post 'upload a file for a particular tool export object' do
  #     tags 'ToolExports'
  #     produces 'application/json'
  #     consumes 'multipart/form-data'
  #     security [apiToken: []]
  #     parameter name: 'Content-Type', in: :header, type: :string, required: true
  #     parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Tool Export you wish to access', required: true
  #     parameter name: :file, in: 'formData', type: :file, description: 'the file to be uploaded to the Rise Tool Export engine', required: true
  #     response '200', 'OK' do
  #       let(:current_user) { create(:user) }
  #       let!(:tool_export) { create :tool_export, user: current_user }
  #       let(:'Content-Type') { 'multipart/form-data' }
  #       let!(:file) { fixture_file_upload('spec/fixtures/files/kanripo_file_1.txt', 'text/txt') }
  #       let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
  #       let(:uuid) { tool_export.uuid }
  #       schema '$ref' => '#/definitions/tool_export'
  #       after do |example|
  #         example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
  #       end
  #       run_test! do |response|
  #         expect(response.body).to include(tool_export.name)
  #       end
  #     end
  #   end
  # end

  path '/api/tool_exports/{uuid}' do
    get 'Retrieves a tool_export' do
      tags 'ToolExports'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Tool Export you wish to access', required: true
      response '200', 'OK' do
        let(:current_user) { create(:user) }
        let!(:tool_export) { create :tool_export, user: current_user }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { tool_export.uuid }
        schema '$ref' => '#/definitions/tool_export'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(tool_export.name)
        end
      end

      response '404', 'resource not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '401', 'no access to this tool export' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:tool_export).uuid }
        run_test!
      end
    end
  end
end
