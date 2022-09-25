import { NextPage } from "next";

import { Layout } from "@/components/templates";
import { Auth } from "@/components/templates/auth";

const Home: NextPage = () => {
  return (
    <Layout title="ログイン">
      <Auth />
    </Layout>
  );
};
export default Home;
