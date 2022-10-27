/**
 * APIのレスポンスを意図的に遅らせる関数
 */
export const delay = (ms: number) => {
  return new Promise((resolve) => {
    // 指定した時間が経過後、resolve()を実行し、Promiseのstateをpendingからfulfilledに変更
    setTimeout(resolve, ms)
  })
}
