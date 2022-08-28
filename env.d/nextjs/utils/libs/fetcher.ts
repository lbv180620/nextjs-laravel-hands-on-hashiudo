import fetch from 'isomorphic-unfetch';

const defaultTimeoutMs = 10 * 1000;

// catchした際にタイムアウトによるエラーかそれ以外のエラーか判別するため
export class TimeoutError extends Error {}

const timeout = <T>(task: Promise<T>, ms?: number) => {
  const timeoutMs = ms || defaultTimeoutMs;
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const timeoutTask = new Promise((resolve, _) => {
    setTimeout(resolve, timeoutMs);
  }).then(() => Promise.reject(new TimeoutError(`Operation timed out after ${timeoutMs} ms`)));

  return Promise.race([task, timeoutTask]);
};

const wrap = <T>(task: Promise<Response>): Promise<T> => {
  return new Promise((resolve, reject) => {
    task
      .then((response) => {
        if (response.ok) {
          response
            .json()
            .then((json: Promise<T>) => {
              resolve(json);
            })
            .catch((error) => {
              reject(error);
            });
        } else {
          reject(response);
        }
      })
      .catch((error) => {
        reject(error);
      });
  });
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const fetcher = <T = any>(input: RequestInfo | URL, init?: RequestInit | undefined): Promise<T> => {
  return wrap<T>(timeout(fetch(input, init)));
};

export default fetcher;
