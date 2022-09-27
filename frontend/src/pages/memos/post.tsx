import { NextPage } from "next";
import { ChangeEvent, useCallback } from "react";

import { PrimaryInput, PrimaryTextarea } from "@/components/atoms";
import { FormLayout, Layout } from "@/components/templates";
import { useMemoPost } from "@/hooks";
// import { MemoFormType } from "@/types";

const PostPage: NextPage = () => {
  //* hooks
  const { memoForm, setMemoForm, createMemo } = useMemoPost();

  // console.log(memoForm);

  //* local state
  // const [validation, setValidation] = useState<MemoFormType>({
  //   title: "",
  //   body: "",
  // });

  //* event
  // POSTデータの更新
  const updateMemoForm = useCallback(
    (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
      setMemoForm({ ...memoForm, [e.target.name]: e.target.value });
    },
    [memoForm, setMemoForm]
  );

  return (
    <Layout title="メモの登録">
      <FormLayout title="メモの登録" btnTitle="登録する" onClick={createMemo}>
        <PrimaryInput text="タイトル" name="title" value={memoForm.title} onChange={updateMemoForm} />
        <PrimaryTextarea text="メモの内容" value={memoForm.body} onChange={updateMemoForm} />
      </FormLayout>
    </Layout>
  );
};

export default PostPage;
