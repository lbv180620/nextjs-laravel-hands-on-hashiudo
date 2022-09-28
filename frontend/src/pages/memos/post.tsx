import { NextPage } from "next";
import { ChangeEvent, useCallback } from "react";

import { PrimaryInput, PrimaryTextarea } from "@/components/atoms";
import { FormLayout, Layout } from "@/components/templates";
import { useMemoPost } from "@/hooks";

const PostPage: NextPage = () => {
  //* hooks
  const { memoForm, setMemoForm, createMemo, validation } = useMemoPost();

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
        <PrimaryInput
          text="タイトル"
          name="title"
          value={memoForm.title}
          onChange={updateMemoForm}
          message={validation.title}
        />
        <PrimaryTextarea text="メモの内容" value={memoForm.body} onChange={updateMemoForm} message={validation.body} />
      </FormLayout>
    </Layout>
  );
};

export default PostPage;
