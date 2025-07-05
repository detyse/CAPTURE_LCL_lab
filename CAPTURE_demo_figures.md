# CAPTURE_demo 生成的圖形說明

以下列出 `CAPTURE_quickdemo.m`（即 CAPTURE demo）及其相依程式在執行時會繪製的主要 figure，並說明其目的。行號來自原始程式碼。

## 1. t-SNE 分佈圖（figure 1）
- 位置：`CAPTURE_quickdemo.m` 第 92-94 行【F:CAPTURE_quickdemo.m†L92-L94】。
- 內容：執行 `tsne` 後，將低維座標 `zvals` 以藍色點繪製，呈現所有樣本在 t-SNE 空間的散布情形。

## 2. 叢集著色 t-SNE 圖（figure 609）
- 位置：`CAPTURE_quickdemo.m` 第 113-123 行【F:CAPTURE_quickdemo.m†L113-L123】。
- 內容：呼叫 `plot_clustercolored_tsne`，依照分群結果與 watershed 邊界將 t-SNE 散點圖著色。

## 3. 動畫顯示（figure 370）
- 位置：`CAPTURE_quickdemo.m` 第 126-135 行【F:CAPTURE_quickdemo.m†L126-L135】。
- 內容：在同一 figure 中播放未對齊與對齊後的標記點 3D 動畫。

## 4. 擴充特徵的 t-SNE 圖（figure 2）
- 位置：`CAPTURE_quickdemo.m` 第 140-148 行【F:CAPTURE_quickdemo.m†L140-L148】。
- 內容：若計算額外行為特徵，則於此繪製新的 t-SNE 結果。

## 5. 行為序列相關性矩陣（figure 434）
- 位置：`find_sequences_states_demo.m` 第 88-99 行【F:Behavioral_analysis/find_sequences_states_demo.m†L87-L100】。
- 內容：以 heatmap 顯示不同時間尺度下行為標註的相關性距離。

## 6. 相關係數分布直方圖（figure 5454）
- 位置：`find_sequences_states_demo.m` 第 169-173 行【F:Behavioral_analysis/find_sequences_states_demo.m†L169-L173】。
- 內容：統計相關係數分布，評估行為序列相關程度。

## 7. 整合相關性比較矩陣（figure 55）
- 位置：`find_sequences_states_demo.m` 第 186-191 行【F:Behavioral_analysis/find_sequences_states_demo.m†L186-L191】。
- 內容：比較不同行為類型的整合相關性。

## 8. 叢集行為成分可視化（figure 395+ll，例：figure 396）
- 位置：`find_sequences_states_demo.m` 第 318-324 行【F:Behavioral_analysis/find_sequences_states_demo.m†L318-L324】。
- 內容：於每個時間尺度 `ll` 的 `figure(395+ll)` 中，以透明度表示各叢集的行為組成，第一個尺度對應 `figure 396`。

## 9. 關節平面角度比較（figure 68）
- 位置：`get_planar_jointangles.m` 第 37-41 行【F:Utility/get_planar_jointangles.m†L37-L41】。
- 內容：繪製關節在平面內與離平面角度的時間序列，用以檢視關節運動特性。

## 10. t-SNE 密度圖（figure 480）
- 位置：`cluster_tsne_maps.m` 第 19-30 行【F:Clustering/cluster_tsne_maps.m†L19-L30】。
- 內容：對各條件計算 t-SNE 點密度並以子圖呈現，最後一個子圖為所有資料的密度。

## 11. Watershed 結果（figure 482）
- 位置：`cluster_tsne_maps.m` 第 54-55 行【F:Clustering/cluster_tsne_maps.m†L54-L55】。
- 內容：顯示密度圖經 watershed 分割後的區域標籤。

## 12. 姿態均值層次聚類（figure 1112）
- 位置：`cluster_tsne_maps.m` 第 279-284 行【F:Clustering/cluster_tsne_maps.m†L279-L284】。
- 內容：對每個叢集平均姿態進行 linkage 分析並繪製 dendrogram。

## 13. 平均姿態距離矩陣（figure 1111）
- 位置：`cluster_tsne_maps.m` 第 294-298 行【F:Clustering/cluster_tsne_maps.m†L294-L298】。
- 內容：繪製叢集平均姿態的歐氏距離矩陣熱圖。

## 14. 分群對照視覺化（figure 487）
- 位置：`cluster_tsne_maps.m` 第 320-347 行【F:Clustering/cluster_tsne_maps.m†L320-L347】。
- 內容：左右子圖分別呈現重排序前後的 watershed 叢集，並標註區域編號。
