// import { configureStore, ThunkAction, Action } from '@reduxjs/toolkit';
// import { rootReducer } from './rootReducer';
// import { createBrowserHistory } from 'history';
// import { routerMiddleware } from 'connected-react-router';
// import { createLogger } from 'redux-logger';

// //* history
// export const history = createBrowserHistory();

// //* logger
// const logger = createLogger({
//   collapsed: true,
//   diff: true,
// });

// //* store
// export const store = configureStore({
//   reducer: rootReducer(history),
//   middleware: (getDefaultMiddleware) => getDefaultMiddleware().concat(routerMiddleware(history)).concat(logger),
//   devTools: process.env.NODE_ENV !== 'production',
// });

// //* types
// export type AppDispatch = typeof store.dispatch;
// export type RootState = ReturnType<typeof store.getState>;
// export type AppThunk<ReturnType = void> = ThunkAction<ReturnType, RootState, unknown, Action<string>>;
