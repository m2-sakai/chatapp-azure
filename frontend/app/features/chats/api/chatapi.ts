import { API_ROUTES } from './route';

export async function fetchToken(): Promise<string> {
  const response = await fetch(API_ROUTES.GET_TOKEN);

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`Failed to fetch token: ${response.status} - ${errorMessage}`);
  }

  const { url } = await response.json();
  return url;
}
