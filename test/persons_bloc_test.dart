import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testingbloc/bloc/bloc_actions.dart';
import 'package:testingbloc/bloc/person.dart';
import 'package:testingbloc/bloc/persons_bloc.dart';

const mockedPersons1 = [
  Person(
    age: 20,
    name: 'Foo',
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

const mockedPersons2 = [
  Person(
    age: 20,
    name: 'Foo',
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

Future<Iterable<Person>> mockGetPersons1(String _) => Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) => Future.value(mockedPersons2);

void main() {
  group(
    'Testing bloc',
    () {
      // write our tests
      late PersonsBloc bloc;

      setUp(() {
        bloc = PersonsBloc();
      });

      blocTest<PersonsBloc, FetchResult?>(
        'Test Initial State of Bloc',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      //fetch mock data (persons1) and compare it with FetchResult

      blocTest(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: true,
          ),
        ],
      );

      //fetch mock data (persons2) and compare it with FetchResult
      blocTest(
        'Mock retrieving persons from second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}
