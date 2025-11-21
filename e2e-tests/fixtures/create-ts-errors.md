This will get a TypeScript error.

<code-fighter-write path="src/bad-file.ts" description="This will get a TypeScript error.">
import NonExistentClass from 'non-existent-class';

const x = new Object();
x.nonExistentMethod();
</code-fighter-write>

EOM
