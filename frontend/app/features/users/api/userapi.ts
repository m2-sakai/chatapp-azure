import { API_ROUTES } from './route';

export async function fetchUserData(email: string | null): Promise<any> {
  if (!email) {
    throw new Error('Email is required to fetch user data');
  }

  const response = await fetch(`${API_ROUTES.GET_USER}?email=${email}`);

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`Failed to fetch user data: ${response.status} - ${errorMessage}`);
  }

  const userData = await response.json();
  return userData;
}

export async function insertUser(name: string | null, email: string | null): Promise<void> {
  const response = await fetch(API_ROUTES.INSERT_USER, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name,
      email,
    }),
  });

  if (!response.ok) {
    const errorMessage = await response.json();
    throw new Error(errorMessage);
  }
}
