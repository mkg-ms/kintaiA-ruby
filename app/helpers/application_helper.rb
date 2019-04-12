module ApplicationHelper
  
  

  # ページごとにタイトルを返す。
  def full_tiltle(page_title: "")# メソッド名と引数の定義
    base_title = "勤怠管理システム" # 変数に代入
    if page_tiltle.empty? # 引数の論理値確認
      base_title # page_titleが空("")の時は既に定義してあるbase_titleを返す。
    else
      page_title + " | " + base_title # 文字列を結合して返す。
    end
  end
  
end
