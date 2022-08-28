import { NextPage } from 'next';

import { PrimaryInput, PrimaryTextarea } from '@/components/atoms';
import { FormLayout } from '@/components/templates';

const PostPage: NextPage = () => {
  return (
    <FormLayout title="メモの登録" btnTitle="登録する">
      <PrimaryInput text="タイトル" name="title" />
      <PrimaryTextarea text="メモの内容" />
    </FormLayout>
  );
};

export default PostPage;
