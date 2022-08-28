import { NextPage } from 'next';

import { PasswordInput, PrimaryInput } from '@/components/atoms';
import { FormLayout } from '@/components/templates';

const Home: NextPage = () => {
  return (
    <FormLayout title="ログイン" btnTitle="ログイン">
      <PrimaryInput text="メールアドレス" name="email" />
      <PasswordInput />
    </FormLayout>
  );
};
export default Home;
