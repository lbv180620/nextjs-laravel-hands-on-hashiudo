import { BASE_URL } from '@/common';
import { PostType, TodoType } from '@/types';

import fetcher from './fetcher';

export const getAllPostData = async () => {
  // ’?_limit=10' → 10件取得という意味
  const posts = await fetcher<PostType[]>(`${BASE_URL}/posts/?_limit=10`);
  return posts;
};

export const getAllTaskData = async () => {
  const todos = await fetcher<TodoType[]>(`${BASE_URL}/todos/?_limit=10`);
  return todos;
};

export const getAllPostIds = async () => {
  const posts = await fetcher<PostType[]>(`${BASE_URL}/posts/?_limit=10`);
  return posts.map((post) => ({
    params: {
      // endpointにidのパラメータを渡して個別にデータを取得するために、文字列型に変換しておく。
      id: String(post.id),
    },
  }));
};

export const getPostDataById = async (id: string) => {
  const post = await fetcher<PostType>(`${BASE_URL}/posts/${id}`);
  return post;
};

// ! fetchの型の付け方が分からない
// export const getAllPostIds = async () => {
//   const res = await fetch(new URL(`${BASE_URL}/posts/?_limit=10`));
//   const posts = await res.json();
//   return posts.map((post) => ({
//     params: {
//       id: String(post.id),
//     },
//   }));
// };

// const res = await axios.get<PostType[]>(`${BASE_URL}/posts/?_limit=10`);
// const posts = res.data;
// return posts;

// const fetchPostsData = async (url: string): Promise<PostType[]> => await fetch(url).then((res) => res.json());
// const posts = await fetchPostsData(`${BASE_URL}/posts/?_limit=10`);
// return posts;

// const res = await fetch(new URL(`${BASE_URL}/posts/?_limit=10`));
// const posts = (await res.json()) as PostType[];
// return posts;
